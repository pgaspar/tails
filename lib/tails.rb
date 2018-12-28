# frozen_string_literal: true

require 'tails/version'
require 'tails/routing'

module Tails
  class Application
    def call(env)
      router = Routing.new
      klass, action = router.get_controller_and_action(env)
      controller = klass.new(env)
      body = controller.public_send(action.to_sym)
      [200, { 'Content-Type' => 'text/html' }, [body]]
    end
  end

  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
    end
  end
end
