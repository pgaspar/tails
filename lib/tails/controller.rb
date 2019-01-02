# require 'erubis'
require 'tails/file_model'
require 'rack/request'

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
      text = eruby.result locals.merge(env: env)
      response text
    end

    def controller_name
      klass = self.class
      klass_name = klass.to_s.gsub(/Controller$/, '')
      Tails.to_underscore klass_name
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params
    end

    def response(text, status = 200, headers = { 'Content-Type' => 'text/html' })
      raise 'Already responded!' if @response

      @response = Rack::Response.new(
        [text].flatten,
        status,
        headers
      )
    end

    def get_response
      @response
    end
  end
end
