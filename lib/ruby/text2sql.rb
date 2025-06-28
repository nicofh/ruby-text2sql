# frozen_string_literal: true

require "openai"
require_relative "text2sql/schema_parser"
require_relative "text2sql/sql_executor"
require_relative "text2sql/version"

module Ruby
  module Text2sql
    class Error < StandardError; end

    class Configuration
      attr_accessor :allowed_actions

      def initialize
        @allowed_actions = [:select]
      end
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    class << self
      def call(user_request)
        # Step 1: Parse the schema automatically
        schema = SchemaParser.new.parse

        # Step 2: Generate SQL query using OpenAI
        sql_query = generate_sql_query(user_request, schema)

        # Step 3: Execute the generated SQL query using SQLExecutor, using configured allowed_actions
        query_result = SQLExecutor.new(allowed_actions: Ruby::Text2sql.configuration.allowed_actions,
                                       sql_query: sql_query).execute

        # Step 4: Generate a natural language response from the query result
        natural_language_response = generate_response(user_request, query_result)

        {
          sql_query: sql_query,
          query_result: query_result,
          natural_language_response: natural_language_response
        }
      end

      private

      def client
        @client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY", nil))
      end

      def generate_sql_query(user_request, schema)
        full_prompt = "Ruby Schema:\n#{schema}\n\n
                      User Request: #{user_request}\n\n
                      Generate only the SQL query to answer the request.
                      Do not include any explanation or additional text.
                      If the request doesn't make sense just return 'SELECT '#{user_request}';'."

        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "system", content: "You are an expert SQL generator." },
                       { role: "user", content: full_prompt }]
          }
        )

        response["choices"][0]["message"]["content"].strip
      end

      def generate_response(user_request, query_result)
        result_prompt = "User Request: #{user_request}\n
                         SQL Query Result: #{query_result.inspect}\n\n
                         Answer the user's request in natural language. Answer in the same language as the question"

        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "system", content: "You are an expert at explaining query results in plain language." },
                       { role: "user", content: result_prompt }]
          }
        )

        response["choices"][0]["message"]["content"].strip
      end
    end
  end
end
