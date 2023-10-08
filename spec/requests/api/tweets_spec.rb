require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do
  describe 'POST /api/tweets' do
    let(:user) { FactoryBot.create(:user) }
    let(:tweet) { FactoryBot.create(:tweet) }

    it 'returns unauthorized status when not authenticated' do
      post '/api/tweets'
      expect(response).to have_http_status(401)
    end

    it 'should return a successful 201 for creating a tweet and validation for the JSON schema' do
      token = Api::JsonWebToken.encode({ id: user.id })
      post '/api/tweets',
        params: {
          tweet: {
            body: "New body",
            user_id: user.id,
            retweet_id: nil,
            quote_id: nil,
            parent_tweet_id: nil
          }
        },
        headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(201)
      expect(response).to response_schema("tweet")
    end
  end

  describe 'GET /api/tweets' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns unauthorized status when not authenticated' do
      get '/api/tweets'
      expect(response).to have_http_status(401)
    end

    it 'returns a list of tweets when authenticated' do
      FactoryBot.create(:tweet, user: user, body: 'Tweet 1')
      FactoryBot.create(:tweet, user: user, body: 'Tweet 2')

      token = Api::JsonWebToken.encode(id: user.id)
      get '/api/tweets', headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(200)
      expect(response).to response_schema("tweet")
    end
  end

  describe 'PUT /api/tweets/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:tweet) { FactoryBot.create(:tweet, user: user, body: 'Original tweet') }

    it 'returns unauthorized status when not authenticated' do
      put "/api/tweets/#{tweet.id}"
      expect(response).to have_http_status(401)
    end

    it 'returns a successful 200 for updating a tweet' do
      token = Api::JsonWebToken.encode(id: user.id)
      updated_body = 'Updated tweet body'

      put "/api/tweets/#{tweet.id}",
        params: {
          tweet: {
            body: 'Updated tweet body'
          }
        },
        headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(200)
      expect(response).to response_schema("tweet")
    end
  end

  describe 'DELETE /api/tweets/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:tweet) { FactoryBot.create(:tweet, user: user) }

    it 'returns unauthorized status when not authenticated' do
      delete "/api/tweets/#{tweet.id}"
      expect(response).to have_http_status(401)
    end

    it 'returns a successful 200 for deleting a tweet' do
      token = Api::JsonWebToken.encode(id: user.id)
      delete "/api/tweets/#{tweet.id}",
        headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['message']).to eq('Tweet deleted successfully')
    end
  end

  describe 'POST /api/tweets/:id/like' do
    let(:user) { FactoryBot.create(:user) }
    let(:tweet) { FactoryBot.create(:tweet) }

    it 'returns unauthorized status when not authenticated' do
      post "/api/tweets/#{tweet.id}/like"
      expect(response).to have_http_status(401)
    end

    it 'returns a successful 200 for liking a tweet' do
      token = Api::JsonWebToken.encode(id: user.id)
      post "/api/tweets/#{tweet.id}/like",
        headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['message']).to eq('Liked the tweet!')
    end
  end

  describe 'DELETE /api/tweets/:id/unlike' do
    let(:user) { FactoryBot.create(:user) }
    let(:tweet) { FactoryBot.create(:tweet) }

    it 'returns unauthorized status when not authenticated' do
      delete "/api/tweets/#{tweet.id}/unlike"
      expect(response).to have_http_status(401)
    end

    it 'returns a successful 200 for unliking a tweet' do
      token = Api::JsonWebToken.encode(id: user.id)
      like = Like.create(user: user, tweet: tweet)
      delete "/api/tweets/#{tweet.id}/unlike",
        headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['message']).to eq('Unliked the tweet.')
    end
  end

  describe 'POST /api/tweets/:id/retweet' do
    let(:user) { FactoryBot.create(:user) }
    let(:tweet) { FactoryBot.create(:tweet) }

    it 'returns unauthorized status when not authenticated' do
      post "/api/tweets/#{tweet.id}/retweet"
      expect(response).to have_http_status(401)
    end

    it 'creates a retweet and returns a successful 201 response' do
      token = Api::JsonWebToken.encode({ id: user.id })

      expect {
        post "/api/tweets/#{tweet.id}/retweet",
          headers: { "Authorization" => "Bearer #{token}" }
      }.to change(Tweet, :count).by(2)

      expect(response).to have_http_status(201)
    end
  end
end
