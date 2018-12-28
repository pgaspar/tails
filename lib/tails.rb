# frozen_string_literal: true

require 'tails/version'

module Tails
  class Application
    def call(env)
      [200, { 'Content-Type' => 'text/html' }, ['Hello from Ruby on Tails!']]
    end
  end
end
