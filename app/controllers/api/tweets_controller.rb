class Api::TweetsController < ApiController
    before_action :set_tweet, only: %i[ show edit update destroy ]
    before_action :set_default_format
    include TweetsConcerns
    before_action :authenticate_user!
    
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


    def like
        tweet = Tweet.find(params[:id])
        create_like(current_user, tweet)
    end

    def unlike
        tweet = Tweet.find(params[:id])
        delete_like(current_user, tweet)
    end



    def retweet
        tweet = Tweet.find(params[:id])

        retweet_tweet = create_retweet(current_user, tweet)
        if retweet_tweet
            render json: retweet_tweet, status: :created
        else
            render json: { error: "Retweet Already exist"}
        end
    end

    def quote 
        tweet = Tweet.find(params[:id])
        body =  params[:new_body]
        quote_tweet = create_quote(current_user,body)

        if quote_tweet
            render json: quote_tweet, status: :created
        else
            render json: { error: "Quote Already exist"}
        end
    end


    def reply 
        tweet = Tweet.find(params[:id])
        body =  params[:new_body]
        reply_tweet = create_reply(current_user, tweet, body)
        if reply_tweet
            render json: reply_tweet, status: :created
        else
            render json: { error: "Reply Already exist"}
        end
    end


    def bookmark
        tweet = Tweet.find(params[:id])
        bookmark = create_bookmark(current_user, tweet)
        if bookmark
            render json: reply_tweet, status: :created
        else
            render json: { error: "Already exist in The Bookmark"}
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
