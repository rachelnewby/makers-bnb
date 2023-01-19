require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.


  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Sign up to MakersBnB </p>')
    end
  end
  
  context 'GET /login' do
    it 'should get the login page' do
      response = get('/login')

      expect(response.status).to eq(200)
    end
  end

  context 'GET to /book' do
    it 'renders the book page' do
      # post(
      #   '/register',
      #   username: 'tester',
      #   firstname: 'Testy',
      #   lastname: 'McTest',
      #   email: 'tester@test.com',
      #   password: 'password'
      # )

      
      response = post(
        '/login',
        username: 'tester',
        password: 'password'
      )

      response = get('/spaces')
      expect(response.body).to include('<h1>Book a Space </h1>')

      # response = get('/book/1')
      # expect(response.status).to eq 200
      # space = Space.find(1)
      # expect(response.body).to include(space.description)
    end
  end
end
