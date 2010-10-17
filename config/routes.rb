Jrnl::Application.routes.draw do
  devise_for :users

  resources :posts
  root :to => "posts#index"
  match 'atom.xml' => "posts#index"
end
