class Tweet < ApplicationRecord
    belongs_to :user
    validates :body, presence: true
    has_many :likes 
    has_many :retweets, class_name: "Tweet", foreign_key: "retweet_id"

    scope :tweets_for_me, ->(t_friends) { where(user_id: t_friends) }

    # like the tweet
    def like(user)
        likes << Like.new(user: user)
    end

    # unlike the tweet
    def unlike(user)
        #likes.where(user_id: user.id).first.destroy
        likes.find_by(user_id: user.id).destroy
    end

    def self.search(search)
        where("body LIKE ?", "%#{search}%")
    end
end
