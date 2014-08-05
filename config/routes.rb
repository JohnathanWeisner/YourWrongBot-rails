Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'pages#index'
  get 'subreddits/', to: 'subreddits#index'
  get 'subreddits/:subreddit', to: 'subreddits#show'
  get 'about', to: 'pages#about', as: 'about'
end
