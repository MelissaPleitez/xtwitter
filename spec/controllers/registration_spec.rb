require 'rails_helper'

RSpec.describe Api::RegistrationController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            name: 'John Doe',
            username: 'johndoe',
            email: 'john@example.com',
            password: 'password123'
          }
        }
      end

      it 'creates a new user' do
        expect do
          post :create, params: valid_params
        end.to change(User, :count).by(1)
      end

      it 'returns a 200 status code' do
        post :create, params: valid_params
        expect(response).to have_http_status(200)
      end

      it 'returns a JSON response with a token' do
        post :create, params: valid_params
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end
  end
end

