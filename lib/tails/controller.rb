# require 'erubis'
require 'tails/file_model'

module Tails
  class Controller
    include Tails::Model

    attr_reader :env

    def initialize(env)
      @env = env
    end

    def render(view_name, locals = {})
      filename = File.join 'app', 'views', controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(env: env)
    end

    def controller_name
      klass = self.class
      klass_name = klass.to_s.gsub(/Controller$/, '')
      Tails.to_underscore klass_name
    end

    def params
      param_pairs = env['QUERY_STRING'].split('&').map { |str| str.split('=') }
      Hash[param_pairs]
    end
  end
end
