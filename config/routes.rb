Jrnl::Application.routes.draw do
  devise_for :users
  resources :posts
  root :to => "posts#index"
  match '/:id' => 'posts#show', :constraints => { :id => /\d+/ }, :as => :permalink
end
