Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'subreddits#index'
  get 'subreddits/:subreddit', to: 'subreddits#show'
  get 'about', to: 'pages#about', as: 'about'
end
