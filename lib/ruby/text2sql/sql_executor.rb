# frozen_string_literal: true

module Ruby
  module Text2sql
    class SQLExecutor
      def execute(sql_query)
        result = ActiveRecord::Base.connection.execute(sql_query)

        result.to_a
      end
    end
  end
end
