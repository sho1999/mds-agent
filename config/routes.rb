Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :agents, controllers: {
    sessions:      'agents/sessions',
    passwords:     'agents/passwords',
    registrations: 'agents/registrations'
  }

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }

  resources :agents, only: [:index, :show, :update] do
    member do
      get 'task'
      get 'top'
      get 'onboarding'
      get 'set_target'
    end
  end

  resources :daily_reports, only: [:new, :create]

  # デフォルトのルート（ログインしていない場合）
  root to: "agents#mypage"
  get '/mypage', to: 'users#show'
end
