Jrnl::Application.routes.draw do
  devise_for :users
  resources :posts
  root :to => "posts#index"
  match '/:id' => 'posts#show', :constraints => { :id => /\d+/ }, :as => :permalink
  match '/archives/:year/:month' => 'posts#monthly_archive', :constraints => { :year => /\d{4}/, :month => /\d{1,2}/ }, :as => :monthly_archive
end
