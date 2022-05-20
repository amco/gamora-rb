Rails.application.routes.draw do
  mount Gamora::Engine => "/auth"
  root "home#index"
end
