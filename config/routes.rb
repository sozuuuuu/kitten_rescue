Rails.application.routes.draw do
  resources :deals
  resources :admin_users, param: :uid do
    resources :adoption_requests, except: [:new, :create], controller: 'admin_users/adoption_requests'
    resources :approved_adoption_requests, only: [:create], controller: 'admin_users/approved_adoption_requests'
  end
  resources :users, param: :uid do
    resources :adoption_requests, only: [:index, :new, :create], controller: 'users/adoption_requests'
    resources :kitten_requests, only: [:index, :new, :create], controller: 'users/kitten_requests'
  end

  # resources :adoption_requests, except: [:new, :create]
  mount RailsEventStore::Browser => '/res' if Rails.env.development?
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
