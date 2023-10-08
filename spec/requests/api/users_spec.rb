require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:token) { Api::JsonWebToken.encode({ id: user.id }) }
  let(:user_attributes) { FactoryBot.attributes_for(:user) }

  describe 'GET /api/users' do
    it 'returns a list of users' do
      get '/api/users', headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(200)
      expect(response).to response_schema('user')
    end
  end

  describe 'GET /api/users/:id' do
    it 'returns a user by id' do
      get "/api/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(200)
      expect(response).to response_schema('user')
    end
  end

  describe 'POST /api/users' do
    it 'creates a new user' do
      post '/api/users', params: { user: user_attributes }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(201)
      expect(response).to response_schema('user')
    end
  end

  describe 'PUT /api/users/:id' do
    it 'updates a user by id' do
      new_attributes = { username: 'new_username' }

      put "/api/users/#{user.id}", params: { user: new_attributes }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(200)
      expect(response).to response_schema('user')
    end
  end
end
