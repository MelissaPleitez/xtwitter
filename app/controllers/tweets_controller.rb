class TweetsController < ApplicationController




    def index 
        @tweets = Tweet.new
    end

    def show 
    end

    def create 
        @tweets = Tweet.new(tweet_params)

        response_to do |format|
            if @tweet.save
                format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
                format.json { render json: @tweet, status: :created }
              else
                format.html { render :new }
                format.json { render json: @tweet.errors, status: :unprocessable_entity }
              end
        end
    end

    def edit 

    end

    def update 
        
    end

    private

    def tweet_params
        params.require(:tweet).permit(:body)
    end
end
