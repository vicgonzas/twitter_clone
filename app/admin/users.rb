ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :username, :avatar
  #
  # or
  #
  permit_params do
    permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :username, :avatar]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  index do
    selectable_column
    id_column
    column :email
    column :username
    column "Tweets by Users", :tweet_by_user, sortable: :like_by_user do |user|
      user.tweets.count    
    end
    column "Likes by Users", :like_by_user, sortable: :like_by_user do |user|
      user.likes.count    
    end
    column "Retweets by Users", :rt_by_user, sortable: :rt_by_user do |user|
      user.tweets.where.not(retweet_id: nil).count
    end
    column "Friends by Users", :friend_by_user, sortable: :friend_by_user do |user|
      user.friends.count
    end
    actions
  end

  action_item :active, only: :show do 
    link_to "Active", active_admin_user_path(user), method: :put if !user.active? 
  end

  action_item :deactive, only: :show do 
    link_to "Deactive", deactive_admin_user_path(user), method: :put if user.active? 
  end 

  member_action :active, method: :put do 
    user = User.find(params[:id])
    user.update(active: true)
    redirect_to admin_user_path(user)
  end 

  member_action :deactive, method: :put do 
    user = User.find(params[:id])
    user.update(active: false)
    redirect_to admin_user_path(user)
  end 
end