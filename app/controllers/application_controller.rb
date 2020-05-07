class ApplicationController < ActionController::Base
    #para evitar error ActionController::InvalidAuthenticityToken
    protect_from_forgery with: :null_session 
   
end
