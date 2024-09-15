# frozen_string_literal: true

module Ruby
  module Text2sql
    class SchemaParser
      SCHEMA_PATH = "db/schema.rb"

      def initialize
        @schema = File.read(SCHEMA_PATH)
      end

      # Parses the schema to extract table and column information, including column types
      def parse
        tables = []
        @schema.each_line do |line|
          # Extract table names
          if line =~ /create_table "(.*?)"/
            tables << { table: Regexp.last_match(1), columns: [] }

          # Extract column types and names
          elsif line =~ /t\.(\w+) "(.*?)"/
            column_type = Regexp.last_match(1)
            column_name = Regexp.last_match(2)
            tables.last[:columns] << { name: column_name, type: column_type } if tables.any?
          end
        end
        tables
      end
    end
  end
end
