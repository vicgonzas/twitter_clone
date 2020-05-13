class Api::TweetsController < ApplicationController
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    http_basic_authenticate_with name: "hello", password: "world", except: :news

    def news
        
        if params[:fecha1] && params[:fecha2]
            @tweets = Tweet.all.where(created_at: (params[:fecha1])..params[:fecha2])
        else
            @tweets = Tweet.all.order('created_at DESC').limit 50
            new = []
            @tweets.each do |tweet|
                new = new.push([id: tweet.id, body: tweet.body, user_id: tweet.user_id, tweet_likes: tweet.likes.count, tweet_retweet: tweet.retweets.count])
            end 
            @tweets = new
        end 
        render json: @tweets
    end 

    def new
        @tweet = Tweet.new
    end

    def create
        @tweet = Tweet.new(tweet_params)   
        
        if @tweet.save
            render json: @tweet, status: :created
        else
            render json: @tweet.errors, status: :unprocessable_entity
        end
        
    end  
    
    private
    
    def tweet_params
        params.require(:tweet).permit(:body, :user_id)   
    end
    
end
