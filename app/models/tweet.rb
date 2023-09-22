class Tweet < ApplicationRecord
    belongs_to :user
    has_many :retweets, class_name: 'Tweet', foreign_key: :retweet_id
    has_many :quotes, class_name: 'Tweet', foreign_key: :quote_id
    has_many :replies
    has_many :hashtags
    has_many :bookmarks
    has_many :likes

    validates_associated :user
    validates_associated :retweets
    validates_associated :quotes

    validates :body, length: {maximum: 255}
    validates :body, presence: true, if: :tweet_or_quote?


    def tweet_or_quote?
        retweet_id.nil?
    end

    scope :tweets_by_user, ->(user_id) { where(user_id: user_id) }

    scope :tweets_and_replies_by_user, ->(user_id) do
        where(user_id: user_id).includes(:replies)
    end

    def self.create_retweet(user_id) 

        orig_tweet = Tweet.find_by(retweet_id:nil, user_id: user_id )

        if orig_tweet.nil?
            return nil
        end

        retweet= Tweet.new(user_id: user_id, retweet_id: orig_tweet.id)

        if retweet.save
            return retweet
        else
            return nil
        end
    end

    def self.create_quote_retweet(user_id, body) 

        orig_tweet = Tweet.find_by(retweet_id:nil, user_id: user_id )

        if orig_tweet.nil?
            return nil
        end

        retweet_body= Tweet.new(user_id: user_id, retweet_id: orig_tweet.id, body:body)

        if retweet_body.save
            return retweet_body
        else
            return nil
        end
    end


    def like_tweet(user_id)
        orig_likes = Like.find_by(user_id: user_id )

        if orig_likes
            return false
        end

        likes_tweets = Like.new(user_id: user_id, retweet_id: user_id)
        
        if likes_tweets.save
            return true
        else
            return false
        end

    end

    def self.create_hashtag(tweet)
        tweet_body = tweet.body

        delete_hashtag = tweet_body.scan(/#\w+/).map {|hashtag_text| hashtag_text[1..-1] }
        
        
        delete_hashtag.each do |hash_text|

        hashtag = Hashtag.find_or_create_by(name: hash_text)

        hashtag_new = Hashtag.new(name:hashtag)

        if hashtag_new.nil?
            return nil
        else
            return hashtag_new
        end
     
        end
    end


end
