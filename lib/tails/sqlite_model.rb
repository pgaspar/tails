require 'sqlite3'
require 'tails/util'

DB_NAME = 'test.db'.freeze
DB = SQLite3::Database.new DB_NAME

module Tails
  module Model
    class SQLite
      def self.table
        Tails.to_underscore name
      end

      def self.schema
        @schema ||= begin
          DB.table_info(table).each_with_object({}) do |row, schema|
            schema[row['name']] = row['type']
          end
        end
      end
    end
  end
end
