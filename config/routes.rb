Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root to: "agents#mypage"

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

  resources :agents, only: [:index, :update] do
    member do
      get 'task'
      get 'top'
      get 'onboarding'
      get 'set_target'
      get 'appointment'
      get 'mypage'
    end
  end

  resources :automation, only: [:index]

  resources :daily_reports, only: [:new, :create]

  post 'add_project_500', to: 'automation#add_project_500'
  post 'change_interview_date', to: 'automation#change_interview_date'
  post 'check_uru_task', to: 'automation#check_uru_task'
end
