Rails.application.routes.draw do
  root to: 'requests#new'

  resources 'requests', only: %i[new create] do
    member do
      get 'confirm'
      get 'reconfirm'
    end
  end
end
