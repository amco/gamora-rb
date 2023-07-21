# frozen_string_literal: true

module Gamora
  class CallbackController < ApplicationController
    def show
      access_token = access_token_from_auth_code
      session[:access_token] = access_token.token
      session[:refresh_token] = access_token.refresh_token
      redirect_to session.delete("gamora.origin") || main_app.root_path
    rescue OAuth2::Error
      render plain: "Invalid authorization code"
    end

    private

    def access_token_from_auth_code
      Client.from_config.auth_code.get_token(params[:code])
    end
  end
end
