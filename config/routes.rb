Jrnl::Application.routes.draw do
  root to: 'posts#index'

  devise_for :users

  get '/posts/:id' => redirect('/%{id}'), constraints: { id: /\d+/ }
  get '/posts' => redirect('/')
  get '/posts/index' => redirect('/')
  resources :posts

  get '/:id' => 'posts#show', constraints: { id: /\d+/ }, as: :permalink
  get '/archives/:year/:month' => 'posts#monthly_archive', constraints: { year: /\d{4}/, month: /\d{1,2}/ }, as: :monthly_archive

  get '/admin' => 'admin#index'
end
