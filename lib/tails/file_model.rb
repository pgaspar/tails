require 'multi_json'

module Tails
  module Model
    class FileModel
      DB_DIR = 'db/quotes/'.freeze

      def initialize(filename)
        @filename = filename

        basename = File.split(filename).last
        @id = File.basename(basename, '.json').to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        FileModel.new(DB_DIR + "#{id}.json")
      rescue
        nil
      end

      def self.all
        files = Dir[DB_DIR + '*.json']
        files.map { |f| FileModel.new(f) }
      end
    end
  end
end
