# frozen_string_literal: true

class TestController < Tails::Controller
  def index
    'Hello!'
  end
end

class TestApp < Tails::Application
  def get_controller_and_action(_env)
    [TestController, 'index']
  end
end

RSpec.describe Tails::Application do
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  it 'renders a request' do
    get '/example/route'

    expect(last_response).to be_ok
    body = last_response.body
    expect(body).to include('Hello')
  end
end
