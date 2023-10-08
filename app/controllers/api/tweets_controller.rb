class Api::TweetsController < ApiController
    include TweetsConcerns
    before_action :set_tweet, only: %i[show edit update destroy]
    before_action :set_default_format
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
      # This action is used with HTML
    end
  
    def create
      @tweet = Tweet.new(tweet_params)
  
      respond_to do |format|
        if @tweet.save
          format.json { render :show, status: :created }
        else
          format.json { render json: @tweet.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def edit
      # This action is used with HTML
    end
  
    def update
      respond_to do |format|
        if @tweet.update(tweet_params)
          format.json { render :show, status: :ok }
        else
          format.json { render json: @tweet.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @tweet = Tweet.find(params[:id])
      if @tweet.destroy
        render json: { message: 'Tweet deleted successfully' }, status: :ok
      else
        render json: { error: 'Unable to delete the tweet' }, status: :unprocessable_entity
      end
    end
  
    def like
      @tweet = Tweet.find(params[:id])
      @like = Like.new(user: current_user, tweet: @tweet)
  
      respond_to do |format|
        if @like.save
          format.json { render json: { message: 'Liked the tweet!' }, status: :ok }
        else
          format.json { render json: { error: 'Unable to like the tweet.' }, status: :unprocessable_entity }
        end
      end
    end
  
    def unlike
      @tweet = Tweet.find(params[:id])
      @like = Like.find_by(user: current_user, tweet: @tweet)
  
      respond_to do |format|
        if @like&.destroy
          format.json { render json: { message: 'Unliked the tweet.' }, status: :ok }
        else
          format.json { render json: { error: 'Unable to unlike the tweet.' }, status: :unprocessable_entity }
        end
      end
    end
  
    def retweet
      original_tweet = Tweet.find(params[:id])
      retweet = Tweet.new(
        body: "Retweet: #{original_tweet.body}",
        user: current_user,
        retweet_id: original_tweet.id
      )
  
      if retweet.save
        render json: retweet, status: :created
      else
        render json: { errors: retweet.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def quote
      tweet = Tweet.find(params[:id])
      body = params[:new_body]
      quote_tweet = create_quote(current_user, body, tweet)
  
      if quote_tweet
        render json: quote_tweet, status: :created
      else
        render json: { error: 'Quote Already exist' }, status: :unprocessable_entity
      end
    end
  
    def reply
      tweet = Tweet.find(params[:id])
      body = params[:new_body]
      reply_tweet = create_reply(current_user, tweet, body)
  
      if reply_tweet
        render json: reply_tweet, status: :created
      else
        render json: { error: 'Reply Already exist' }, status: :unprocessable_entity
      end
    end
  
    def bookmark
      tweet = Tweet.find(params[:id])
      bookmark = create_bookmark(current_user, tweet)
  
      if bookmark
        render json: reply_tweet, status: :created
      else
        render json: { error: 'Already exist in The Bookmark' }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end
  
    def tweet_params
      params.require(:tweet).permit(:body, :user_id, :retweet_id, :quote_id, :parent_tweet_id)
    end
  
    # JSON format by default
    def set_default_format
      request.format = :json unless params[:format]
    end
  end
  