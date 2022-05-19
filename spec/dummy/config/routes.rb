Rails.application.routes.draw do
  mount Gamora::Engine => "/auth"
end
