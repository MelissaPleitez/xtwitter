class TweetsController < ApplicationController
    def random
        @random_tweets = Tweet.order("RANDOM()").limit(10)
    end
end