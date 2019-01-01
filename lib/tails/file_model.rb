require 'multi_json'

module Tails
  module Model
    class FileModel
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
        FileModel.new("db/quotes/#{id}.json")
      rescue
        nil
      end
    end
  end
end