Rails.application.routes.draw do

    get '/get_train', to: 'request#get_train_amiens'

end
