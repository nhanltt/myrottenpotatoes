Myrottenpotatoes::Application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :movies do
    resources :reviews
  end
  
  root :to => redirect('/movies')
  
  post '/movies/search_tmdb' 
  
  post '/movies/movies_with_filters'

  get 'auth/:provider/callback' => 'sessions#create'
  get 'auth/failure' => 'sessions#failure'
  get 'auth/twitter', :as => 'login_twitter'
  get 'auth/facebook', :as => 'login_facebook'
  post 'logout' => 'sessions#destroy'
  get 'logout' => 'sessions#destroy'
end
