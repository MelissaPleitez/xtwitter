json.message "Like removed successfully"
json.tweet do
    json.extract! tweet, :id, :body, :user_id, :retweet_id, :quote_id, :parent_tweet_id, :created_at, :updated_at
    json.like_count tweet.like.count
end