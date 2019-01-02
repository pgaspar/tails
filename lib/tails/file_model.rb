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

      def save
        filepath = DB_DIR + "#{@id}.json"
        File.open(filepath, 'w') do |f|
          f.write MultiJson.dump(@hash, pretty: true)
        end
      end

      def self.find(id)
        FileModel.new(DB_DIR + "#{id}.json")
      rescue
        nil
      end

      def self.find_all_by_submitter(submitter)
        all.select { |q| q['submitter'] == submitter }
      end

      def self.all
        files = Dir[DB_DIR + '*.json']
        files.map { |f| FileModel.new(f) }
      end

      def self.create(attrs)
        data = {}
        data['submitter'] = attrs['submitter'] || ''
        data['quote'] = attrs['quote'] || ''
        data['attribution'] = attrs['attribution'] || ''

        files = Dir[DB_DIR + '*.json']
        names = files.map { |f| File.split(f).last }
        highest = names.map(&:to_i).max
        id = highest + 1

        filepath = DB_DIR + "#{id}.json"
        File.open(filepath, 'w') do |f|
          f.write MultiJson.dump(data, pretty: true)
        end

        FileModel.new(filepath)
      end
    end
  end
end
