require 'sqlite3'
require 'tails/util'

DB_NAME = 'test.db'.freeze
DB = SQLite3::Database.new DB_NAME

module Tails
  module Model
    class SQLite
      def initialize(data = {})
        @hash = data
      end

      def self.find(id)
        row = DB.execute <<~SQL
          select #{schema.keys.join(',')} from #{table}
            where id = #{id};
        SQL

        data = Hash[schema.keys.zip row[0]]
        new data
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.to_sql(val)
        case val
        when NilClass
          'null'
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL!"
        end
      end

      def self.create(values)
        values.delete 'id'
        keys = schema.keys - ['id']
        vals = keys.map { |k| to_sql(values[k]) }

        DB.execute <<~SQL
          INSERT INTO #{table} (#{keys.join(',')})
            VALUES (#{vals.join(',')});
        SQL

        raw_vals = keys.map { |k| values[k] }
        data = Hash[keys.zip raw_vals]
        sql = 'SELECT last_insert_rowid();'
        data['id'] = DB.execute(sql)[0][0]
        new(data)
      end

      def save!
        unless @hash['id']
          new_instance = self.class.create(@hash)

          new_instance.fields.each do |k, v|
            self[k] = v
          end

          return true
        end

        fields = @hash.map do |k, v|
          "#{k}=#{self.class.to_sql(v)}"
        end

        DB.execute <<~SQL
          UPDATE #{self.class.table}
          SET #{fields.join(',')}
          WHERE id = '#{@hash['id']}';
        SQL
        true
      end

      def save
        save! rescue false
      end

      def self.count
        DB.execute("SELECT COUNT(*) FROM #{table};")[0][0]
      end

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

      def fields
        @hash
      end
    end
  end
end
