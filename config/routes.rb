# frozen_string_literal: true

Gamora::Engine.routes.draw do
  get "amco", to: "authentication#show", as: :authentication
  get "logout", to: "unauthentication#show", as: :logout
  get "amco/callback", to: "callback#show", as: :callback
end
