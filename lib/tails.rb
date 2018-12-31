# frozen_string_literal: true

require 'tails/version'
require 'tails/routing'
require 'tails/util'
require 'tails/dependencies'
require 'tails/controller'

module Tails
  class Application
    def call(env)
      return not_found if favicon_request?(env)
      return default_response if root_request?(env)

      router = Routing.new
      klass, action = router.get_controller_and_action(env)

      controller = klass.new(env)
      body = controller.public_send(action.to_sym)
      ok body
    end

    private

    def ok(body)
      [200, { 'Content-Type' => 'text/html' }, [body]]
    end

    def not_found
      [404, { 'Content-Type' => 'text/html' }, []]
    end

    def redirect(location)
      [302, { 'Location' => location }, []]
    end

    def default_response
      ok 'Welcome to Tails! Build your app by adding your own controllers.'
    end

    def favicon_request?(env)
      env['PATH_INFO'] == '/favicon.ico'
    end

    def root_request?(env)
      env['PATH_INFO'] == '/'
    end
  end
end
