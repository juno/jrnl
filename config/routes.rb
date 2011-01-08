Jrnl::Application.routes.draw do
  root :to => 'posts#index'

  devise_for :users

  match '/posts' => redirect('/'), :constraints => { :method => 'get' }
  match '/posts/index' => redirect('/')
  resources :posts

  match '/:id' => 'posts#show', :constraints => { :id => /\d+/ }, :as => :permalink
  match '/archives/:year/:month' => 'posts#monthly_archive', :constraints => { :year => /\d{4}/, :month => /\d{1,2}/ }, :as => :monthly_archive

  get '/admin' => 'admin#index'
end
