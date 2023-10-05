require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do
  describe "GET /index" do
    describe "GET /index" do

      it "should return a 302 redirect response for login" do
        get "/api/tweets/"
        expect(response).to have_http_status(302)
      end

      it "should return a successful 200 response and validation for the JSON schema" do
        user = create(:user)
        token = Api::JsonWebToken.encode(sub: user.id)
        get "/api/tweets/", headers: { 'Authorization' => "Bearer #{token}" }
        # puts response.body
        expect(response).to have_http_status(200)
        expect(response).to response_schema('tweet')
      end
    end

    describe "GET /new" do 
      
      it "should return a 302 redirect response for login" do 
        get "/api/tweets/new"
        expect(response).to have_http_status(302)
      end

      it "should return a successful 200 response and validation for the JSON schema" do
        user = create(:user)
        token = Api::JsonWebToken.encode(sub: user.id)
        get "/api/tweets/new", headers: { 'Authorization' => "Bearer #{token}" }
        # puts response.body
        expect(response).to have_http_status(200)
        expect(response).to response_schema('tweet')
      end
    end

    describe "POST /create" do
      it "should return a 302 redirect response for login" do 
        post "/api/tweets", params: { tweet: attributes_for(:tweet)}
        expect(response).to have_http_status(302)
      end

      it "should return a successful 200 response and validation for the JSON schema" do
        user = create(:user)
        token = Api::JsonWebToken.encode(sub: user.id)
        post "/api/tweets", params: { tweet: attributes_for(:tweet)}, headers: { 'Authorization' => "Bearer #{token}" }
        # puts response.body
        expect(response).to have_http_status(200)
        expect(response).to response_schema('tweet')
      end
    end

    describe "GET /edit" do 
      it "should return a 302 redirect response for login" do 
        tweet = create(:tweet)
        get "/api/tweets/#{tweet.id}/edit"
        puts response.body
        expect(response).to have_http_status(302)
      end

      it "should return a successful 200 response and validation for the JSON schema" do
        user = create(:user)
        token = Api::JsonWebToken.encode(sub: user.id)
        tweet = create(:tweet)
        get "/api/tweets/#{tweet.id}/edit", headers: { 'Authorization' => "Bearer #{token}" }
        # puts response.body
        expect(response).to have_http_status(200)
        expect(response).to response_schema('tweet')
      end

    end
     
  end
end