require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
    describe 'POST #create' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      let(:valid_credentials) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123'
          }
        }
      end

      it 'returns a 200 status code' do
        post :create, params: valid_credentials
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response with a token' do
        post :create, params: valid_credentials
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid credentials' do
      let(:invalid_credentials) do
        {
          user: {
            email: 'test@example.com',
            password: 'wrong_password'
          }
        }
      end

      it 'returns a 401 status code' do
        post :create, params: invalid_credentials
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns JSON with error messages' do
        post :create, params: invalid_credentials
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when logged in' do
      let(:user) { create(:user) }
      let(:token) { Api::JsonWebToken.encode(id: user.id) }

      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'returns a 200 status code' do
        delete :destroy
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON with a success message' do
        delete :destroy
        expect(JSON.parse(response.body)).to have_key('message')
      end
    end

    context 'when not logged in' do
      it 'returns a 401 status code' do
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns JSON with an error message' do
        delete :destroy
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end
end
