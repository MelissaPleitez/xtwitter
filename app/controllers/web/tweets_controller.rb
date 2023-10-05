class Web::TweetsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_tweet, only: %i[ show edit update ]
    
    def index
        @tweets = Tweet.all
   
    end

    def show 

    end

    def new
        @tweet = Tweet.new
    end
    
    def edit 

    end

    def create
        @tweet = Tweet.new(tweet_params)
    
        respond_to do |format| 
            if @tweet.save 
                format.html { render :show, notice: "Tweet was successfully created." }
            else 
                format.html { render :new, status: :unprocessable_entity }
            end
        end
    end

    private

    def set_tweet 
        @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:body, :user_id, :retweet_id, :quotes_id, :parent_tweet_id)
    end
end
