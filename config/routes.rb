Rails.application.routes.draw do
  
  get 'placement/update'
    require 'sidekiq/web'
    mount Sidekiq::Web => "/sidekiq"

    
    resources :pages, only: [:index, :new, :create]

    devise_for :users, controllers: {
      sessions: 'users/sessions', registrations: 'users/registrations'
    }

    # devise_for :users, :controllers => { :registrations => "registrations" }

    get 'cancelled', to: 'cancelled#show'
    get 'successful', to: 'successful#show'
    delete 'successful', to: 'successful#destroy'


    resources :order_items
    get 'cart', to: 'cart#show'
    delete 'cart', to: "cart#destroy", as: :delete_cart
    get 'order_items', to: 'order_items#create'


    resources :orders do
      resources :parcels
        resources :quotes

      
    
      get '/froma', to: 'orders#froma', as: :froma
      get '/toa', to: 'orders#toa', as: :toa
      
    end

  


  root to: 'pages#home'

  get 'home', to: "pages#home"
  get 'legal', to: "pages#legal"
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    get 'linkedin', to: redirect('https://www.linkedin.com/company/haastig/')

    resources :autocompletes






  get 'posts', to: "posts#index"

  get 'posts/new', to: "posts#new"

  get 'posts/:id/edit', to: "posts#edit", as: :edit_post

  patch 'posts/:id', to: "posts#update"

  delete 'posts/:id', to: "posts#destroy", as: :delete_post

  get 'posts/:id', to: "posts#show", as: :post 

  post 'posts', to: "posts#create"

end
