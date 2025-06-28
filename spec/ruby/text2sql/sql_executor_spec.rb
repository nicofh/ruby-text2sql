# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ruby::Text2sql::SQLExecutor do
  let(:connection) { instance_double(ActiveRecord::Connection) }
  let(:sql_query) { "SELECT * FROM users" }
  let(:insert_query) { "INSERT INTO users (name) VALUES ('John')" }
  let(:delete_query) { "DELETE FROM users WHERE id = 1" }
  let(:select_result) { [{ "id" => 1, "name" => "John" }] }

  before do
    stub_const("ActiveRecord::Base", Class.new)
    stub_const("ActiveRecord::Connection", Class.new)
    allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
    allow(connection).to receive(:execute).with(sql_query).and_return(select_result)
    allow(connection).to receive(:execute).with(insert_query).and_return(nil)
    allow(connection).to receive(:execute).with(delete_query).and_return(nil)
    allow(ActiveRecord::Base).to receive(:transaction).and_yield
  end

  context "when only :select is allowed" do
    subject(:executor) { described_class.new(allowed_actions: [:select], sql_query: sql_query) }

    it "executes SELECT queries and returns an array" do
      expect(executor.execute).to eq(select_result)
    end

    it "returns failed status for disallowed INSERT" do
      executor = described_class.new(allowed_actions: [:select], sql_query: insert_query)
      result = executor.execute
      expect(result[:status]).to eq(:failed)
      expect(result[:error]).to match(/:insert/)
    end
  end

  context "when :select and :insert are allowed" do
    it "executes INSERT queries and returns success status" do
      executor = described_class.new(allowed_actions: %i[select insert], sql_query: insert_query)
      expect(executor.execute[:status]).to eq(:success)
    end
  end

  context "when :delete is not allowed" do
    it "returns failed status for DELETE" do
      executor = described_class.new(allowed_actions: [:select], sql_query: delete_query)
      result = executor.execute
      expect(result[:status]).to eq(:failed)
      expect(result[:error]).to match(/:delete/)
    end
  end

  context "when :delete is allowed" do
    it "executes DELETE queries and returns success status" do
      executor = described_class.new(allowed_actions: %i[select delete], sql_query: delete_query)
      expect(executor.execute[:status]).to eq(:success)
    end
  end

  context "when an error occurs during execution" do
    it "returns failed status with error message" do
      allow(connection).to receive(:execute).with(insert_query).and_raise(StandardError, "DB error")
      executor = described_class.new(allowed_actions: %i[select insert], sql_query: insert_query)
      result = executor.execute
      expect(result[:status]).to eq(:failed)
      expect(result[:error]).to eq("DB error")
    end
  end
end
