Rails.application.routes.draw do

    get '/test', to: 'request#get_train'
    
end
