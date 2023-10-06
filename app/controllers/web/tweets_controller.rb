class Web::TweetsController < ApplicationController
    include TweetsConcerns
    before_action :authenticate_user!
    before_action :set_tweet, only: %i[ show edit update ]
    
    def index
        @tweets = Tweet.all
   
    end

    def show 

    end

    def new
        @tweet = Tweet.new(user: current_user)
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

    def update 
        respond_to do |format|
            if @tweet.update(tweet_params)
              format.html { redirect_to tweet_url(@tweet), notice: "Tweet was successfully updated." }
            else
              format.html { render :edit, status: :unprocessable_entity }
            end
          end
    end


    def destroy
        @tweet.destroy
    
        respond_to do |format|
          format.html { redirect_to tweets_url, notice: "Tweet was successfully destroyed." }
        end
    end

    def retweet
        @origin_tweet = Tweet.find(params[:id]) 
        retweet = Tweet.new(
          body: nil,
          user_id: current_user,
          retweet_id: @origin_tweet,    
        )

        respond_to do |format| 
            if retweet.save 
                format.html { render :show, notice: "Tweet was successfully created." }
            else 
                format.html { render :show, status: :unprocessable_entity }
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
