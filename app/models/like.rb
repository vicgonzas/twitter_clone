class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

   ## We make sure that one user can only have one like per post
   validates :user_id, uniqueness: {scope: :tweet_id}
end
