require 'rails_helper'

RSpec.describe 'API Users', type: :request do
  describe 'GET /api/users' do
    context 'when authenticated' do
      let(:user) { create(:user) }
      let(:token) { Api::JsonWebToken.encode(id: user.id) }

      before do
 
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'returns a 200 status code' do
        get '/api/users'
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON data with the correct schema' do
        get '/api/users'
        expect(response).to response_schema('user')
      end
    end

    context 'when not authenticated' do
      it 'returns a 401 status code' do
        get '/api/users'
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns JSON data with an error message' do
        get '/api/users'
        expect(response).to response_schema('error')
      end
    end
  end
end
