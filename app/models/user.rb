class User < ApplicationRecord
    attr_accessor :password


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :followees, foreign_key: :follower_id, class_name: 'Follow'
    has_many :followers,foreign_key: :followee_id, class_name: 'Follow'
    has_many :tweets
    has_many :replies
    has_many :bookmarks
    has_many :likes
    # has_many :retweets, foreign_key: :retweet_id, class_name: 'Tweet'
    # has_many :quotes, foreign_key: :quote_id, class_name: 'Tweet'

    validates :email, :username, presence: true, 
        uniqueness: true

    scope :followers_count_by_user, -> (user_id) { where(id: user_id).joins(:followers).count }

    scope :following_count_by_user, -> (user_id) { where(id: user_id).joins(:followees).count }
end