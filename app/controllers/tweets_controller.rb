class TweetsController < ApplicationController
    # before any blog action happens, it will authenticate the user
    before_action :authenticate_user!

    def index
        t_friends = current_user.friends.pluck(:friend_id)
        _tweets = params[:search] ? Tweet.all.tweets_for_me(t_friends).order(id: :desc).search(params[:search]) : Tweet.all.tweets_for_me(t_friends).order(id: :desc)

        tweets_array = _tweets.map do |tweet|
            body_array = tweet.body.split(' ')
            tweet.body = body_array.map { |word| word.include?('#') ? "<a href='#{ tweets_url }?utf8=✓&search=%23#{ word.split('#').last }&commit=Search'>#{word}</a>" : word }.join(' ')

            tweet
        end

        @tweets = Kaminari.paginate_array(tweets_array).page(params[:page])
    end

    def new
        @tweet = Tweet.new
    end

    def create
       @tweet = Tweet.new(tweet_params)
       @tweet.user_id = current_user.id

        if @tweet.save
            redirect_to '/tweets#index'
        else
            render :new
        end
    end   

    def like
        tweet = Tweet.find(params[:tweet_id])
        tweet.like(current_user)
        redirect_to '/tweets#index'
    end 

    def unlike
        tweet = Tweet.find(params[:tweet_id])
        tweet.unlike(current_user)
        redirect_to '/tweets#index'
    end

    def destroy
        @tweet = Tweet.find(params[:id])
        @tweet.destroy
        redirect_to '/', :notice => "Your tweet has been deleted"
    end
   
   
    def retweet
        oldtweet = Tweet.find(params[:id])
        @retweet = Tweet.new(body:oldtweet.body, retweet_id:oldtweet.id, user: current_user)
        @retweet.save
        redirect_to '/tweets#index', :notice => "Your tweet has been retweet"
    end

    def show
        tweet = Tweet.find(params[:id])
        @ids = tweet.likes.ids
    end
    
    
    private
    
    def tweet_params
        params.require(:tweet).permit(:body)   
    end
end
