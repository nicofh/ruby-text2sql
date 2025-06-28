# frozen_string_literal: true

module Ruby
  module Text2sql
    class SQLExecutor
      def initialize(allowed_actions: [:select], sql_query: nil)
        @allowed_actions = allowed_actions.map(&:to_sym)
        @sql_query = sql_query
      end

      def execute
        return { status: :failed, error: "Action ':#{query_type}' is not allowed." } unless query_allowed?(query_type)

        if query_type == :select
          result = ActiveRecord::Base.connection.execute(@sql_query)
          result.to_a
        else
          begin
            ActiveRecord::Base.transaction do
              ActiveRecord::Base.connection.execute(@sql_query)
            end
            { status: :success }
          rescue StandardError => e
            { status: :failed, error: e.message }
          end
        end
      end

      private

      def query_allowed?(action)
        @allowed_actions.include?(action)
      end

      def query_type
        first_word = @sql_query.strip.split.first
        return nil if first_word.nil?

        first_word.upcase.downcase.to_sym
      end
    end
  end
end
