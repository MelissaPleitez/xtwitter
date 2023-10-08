class Web::TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: %i[show edit update]

  def index
    @user = current_user
    @tweets = @user.tweets.includes(:replies, :retweets).order(created_at: :desc)
    followed_user_ids = current_user.followees.pluck(:followee_id)

    @tweets += Tweet.where(user_id: followed_user_ids)
                   .or(Tweet.where(retweet_id: followed_user_ids))
                   .or(Tweet.where(quote_id: followed_user_ids))
                   .order(created_at: :desc)

    @tweet = Tweet.new(user: current_user)
  end

  def load_more
    @tweets = Tweet.page(params[:page]).per(10)
    respond_to do |format|
      format.js
    end
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
        format.html { redirect_to web_tweet_url(@tweet), notice: "Tweet was successfully updated." }
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
      body:  @origin_tweet.body,
      user: current_user,
      retweet_id: @origin_tweet.id 
    )

    respond_to do |format|
      if retweet.save
        format.html { redirect_to web_tweets_path(@origin_tweet), notice: "Retweet was successfully created." }
      else
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  def quote
    @tweet = Tweet.new
    @original_tweet = Tweet.find(params[:id])
    @quote_tweet = Tweet.new(
      body: params[:quote_body],
      user: current_user,
      quote_id: @original_tweet.id 
    )

    respond_to do |format|
      if @quote_tweet.save
        format.html { redirect_to web_tweets_path(@original_tweet), notice: "Tweet was successfully quoted." }
      else
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  def like
    @tweet = Tweet.find(params[:id])
    @like = Like.new(user: current_user, tweet: @tweet)

    respond_to do |format|
      if @like.save
        format.html { redirect_to web_tweet_path(@tweet), notice: "Liked the tweet!" }
      else
        format.html { redirect_to web_tweet_path(@tweet), alert: "Unable to like the tweet." }
      end
    end
  end

  def unlike
    @tweet = Tweet.find(params[:id])
    @like = Like.find_by(user: current_user, tweet: @tweet)

    respond_to do |format|
      if @like&.destroy
        format.html { redirect_to web_tweet_path(@tweet), notice: "Unliked the tweet." }
      else
        format.html { redirect_to web_tweet_path(@tweet), alert: "Unable to unlike the tweet." }
      end
    end
  end

  def reply
    @tweet = Tweet.find(params[:id])
    @reply_tweet = Tweet.new(
      body: params[:body], 
      user: current_user,
      parent_tweet: @tweet 
    )

    respond_to do |format|
      if @reply_tweet.save
        format.html { redirect_to web_tweet_path(@tweet), notice: "The reply was successful." }
      else
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  def stats
    @tweet = Tweet.find(params[:id])
    @like_count = @tweet.likes.count
    @reply_count = @tweet.replies.count
    @retweet_count = @tweet.retweets.count
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:body, :user_id, :retweet_id, :quotes_id, :parent_tweet_id)
  end
end
