require 'rails_helper'

RSpec.describe "Tweets", type: :routing do
  describe "Routes for the creation of a tweet" do
    it "Route to /tweets/new using GET to TweetsController" do
      expect(get('/tweets/new')).to route_to(:controller => "tweets",
      "action"=>"new")
    end
    it "Route to /tweets using POST to TweetsController" do
      expect(post('/tweets')).to route_to(:controller => "tweets",
      "action"=>"create")
    end
    it "Route to /tweets using PUT/PATCH to TweetsController" do
      expect(put('/tweets/1')).to route_to(:controller => "tweets",
      "action"=>"update", id: "1")
    end
    it "Route to /tweets using GET to TweetsController" do
      expect(get('/tweets/:id/edit')).to route_to(:controller => "tweets",
      "action"=>"edit")
    end
  end

  describe "Routes for the creation of like, unlike,retweet,quote,reply,bookmark and stats" do 
    it "Route to /tweets/:id/like using POST to TweetsController" do
      expect(post('/tweets/:id/like')).to route_to(:controller => "tweets",
      "action"=>"like")
    end

    it "Route to /tweets/:id/like using DELETE to TweetsController" do
      expect(delete('/tweets/:id/unlike')).to route_to(:controller => "tweets",
      "action"=>"unlike")
    end

    it "Route to /tweets/:id/retweet using POST to TweetsController" do
      expect(post('/tweets/:id/retweet')).to route_to(:controller => "tweets",
      "action"=>"retweet")
    end

    it "Route to /tweets/:id/quote using POST to TweetsController" do
      expect(post('/tweets/:id/quote')).to route_to(:controller => "tweets",
      "action"=>"quote")
    end

    it "Route to /tweets/:id/reply using GET to TweetsController" do
      expect(get('/tweets/:id/reply')).to route_to(:controller => "tweets",
      "action"=>"reply")
    end

    it "Route to /tweets/:id/bookmark using POST to TweetsController" do
      expect(post('/tweets/:id/bookmark')).to route_to(:controller => "tweets",
      "action"=>"bookmark")
    end
    it "Route to /tweets/:id/stats using GET to TweetsController" do
      expect(get('/tweets/:id/stats')).to route_to(:controller => "tweets",
      "action"=>"stats")
    end
  end
end
