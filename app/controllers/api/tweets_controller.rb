class Api::TweetsController < ApiController
    # before_action :authenticate_user!
    before_action :set_tweet, only: %i[ show edit update destroy ]
    before_action :set_default_format
   
    def index
        @tweets = Tweet.all
        render 'index', formats: :json
    end


    def show
        @tweets = Tweet.find(params[:id])
        render 'show', formats: :json
    end




    def new
        # This action is use with html
    end


    def create
        @tweet = Tweet.new(tweet_params)
   
        respond_to do |format|
            if @tweet.save
                format.json { render :show, status: :created, location: @tweet }
            else
                format.json { render json: @tweet.errors, status: :unprocessable_entity }
            end
        end
    end


    def edit


    # This action is use with html
    end


    def update
        if @tweet.update(tweet_params)
            format.json { render :show, status: :ok, location: @tweet }
          else
            format.json { render json: @tweet.errors, status: :unprocessable_entity }
          end
    end


    






      private


      def set_tweet
          @tweet = Tweet.find(params[:id])
      end
 
      def tweet_params
        params.require(:tweet).permit(:body, :user_id, :retweet_id, :quotes_id, :parent_tweet_id)
      end
 
   # JSON Format by default
      def set_default_format
          request.format = :json unless params[:format]
      end
end
