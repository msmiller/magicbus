Rails.application.routes.draw do
  get 'home/index'
  get 'home/buslog'
  get 'buslog' => 'home#buslog'
  post 'home/broadcast'
  post 'broadcast' => 'home#broadcast', as: 'broadcast'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount RedisBrowser::Web => '/redis-browser'

  root :to => "home#index"
  root 'home#index'

end
