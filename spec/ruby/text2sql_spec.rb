# frozen_string_literal: true

RSpec.describe Ruby::Text2sql do
  it "has a version number" do
    expect(Ruby::Text2sql::VERSION).not_to be_nil
  end

  describe ".call" do
    let(:user_request) { "Show me all users with active subscriptions" }
    let(:parsed_schema) { "parsed schema here" }
    let(:sql_query) { "SELECT * FROM users WHERE subscription_status = 'active';" }
    let(:query_result) { [{ "id" => 1, "name" => "John Doe" }] }
    let(:natural_language_response) { "Here are the users with active subscriptions: John Doe." }
    let(:executor) { instance_double(Ruby::Text2sql::SQLExecutor) }

    before do
      allow(File).to receive(:read).with("db/schema.rb").and_return("")

      # Mock schema parser
      allow(Ruby::Text2sql::SchemaParser).to receive(:parse).and_return(parsed_schema)

      # Mock SQL generator

      # Mock SQL executor
      allow(Ruby::Text2sql::SQLExecutor).to receive(:new).and_return(executor)
      allow(executor).to receive(:execute).and_return(query_result)

      # Mock response generator
      allow(described_class).to receive_messages(generate_sql_query: sql_query,
                                                 generate_response: natural_language_response)
    end

    it "returns the correct SQL query, query result, and natural language response" do
      result = described_class.call(user_request)

      expect(result[:sql_query]).to eq(sql_query)
      expect(result[:query_result]).to eq(query_result)
      expect(result[:natural_language_response]).to eq(natural_language_response)
    end
  end

  describe "private methods" do
    let(:user_request) { "Show me all users with active subscriptions" }
    let(:schema) { "parsed schema here" }
    let(:query_result) { [{ "id" => 1, "name" => "John Doe" }] }
    let(:client) { instance_double(OpenAI::Client) }
    let(:client_response) do
      { "choices" => [{ "message" => { "content" => "SELECT * FROM users WHERE subscription_status = 'active';" } }] }
    end

    before do
      # Mock OpenAI client
      allow(described_class).to receive(:client).and_return(client)
    end

    describe "#generate_sql_query" do
      it "generates the correct SQL query from the user request and schema" do
        allow(client).to receive(:chat).and_return(client_response)

        sql_query = described_class.send(:generate_sql_query, user_request, schema)
        expect(sql_query).to eq("SELECT * FROM users WHERE subscription_status = 'active';")
      end
    end

    describe "#generate_response" do
      it "generates a natural language response from the query result" do
        allow(client).to receive(:chat).and_return(
          { "choices" => [
            { "message" => { "content" => "Here are the users with active subscriptions: John Doe." } }
          ] }
        )

        response = described_class.send(:generate_response, user_request, query_result)
        expect(response).to eq("Here are the users with active subscriptions: John Doe.")
      end
    end
  end
end
