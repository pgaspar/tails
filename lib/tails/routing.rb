# frozen_string_literal: true

module Tails
  class Application
    def get_controller_and_action(env)
      path = env['REQUEST_PATH']
      controller, action = path.split('/').slice(1, 2)
      controller = controller.capitalize + 'Controller'
      [Object.const_get(controller), action]
    end
  end
end
