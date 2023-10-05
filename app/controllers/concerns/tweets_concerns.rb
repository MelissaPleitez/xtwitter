module TweetsConcerns extend ActiveSupport::Concern 


    def create_like(user, tweet)
        like = Like.new(
          tweet_id: tweet,
          user_id: user
        )
    
        like.save!
        like
    end


    def delete_like(user, tweet)
        like = Like.find( tweet_id: tweet,
        user_id: user)
        like.destroy if like 
    end


    def create_retweet(user, tweet) 
        if tweet.retweet_id.present?
            return false 
        end

        retweet = Tweet.new(
          body: nil,
          user_id: user,
          retweet_id: tweet,    
        )
        
        if retweet.save 
            return retweet
        else
            return false
        end
    end

    def create_quote(user, new_body)

        if tweet.quote_id.present?
            return false 
        end

        quote = Tweet.new(
          body: new_body,
          user_id: user,
        )

        quote.save!
        quote.update(
          quote_id: quote.id
          )

        if quote.save 
            return quote
        else
            return false
        end

    end

    def create_reply(user,tweet, new_body = nil)
        
        if tweet.retweet_id.present? || tweet.quote_id.present? || tweet.parent_tweet_id.present? 
            return false
        end

        reply_tweet = Tweet.new(
          body: new_body,
          user_id: user,
        )

        reply_tweet.save!
        reply_tweet.update(
            parent_tweet_id: reply_tweet.id
          )

        reply_tweet.body = new_body if new_body.present?
          if reply_tweet.save 
            return reply_tweet
          else
            return false
          end
        

    end

    def create_bookmark(user, tweet)

        if Bookmark.exists?(user_id:user.id, tweet_id: tweet.id)
            return false 
        end

        bookmark = Bookmark.create(user_id: user, tweet_id: tweet)
        bookmark

    end

    

    

end
 