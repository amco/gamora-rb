# frozen_string_literal: true

module Gamora
  class AuthorizationController < ApplicationController
    include Gamora::Authentication::Headers

    before_action :authenticate_user!

    def show
      if Configuration.authorization_method.call(current_user)
        render json: { message: "Authorized user" }, status: :ok
      else
        render json: { error: "Unauthorized user" }, status: :forbidden
      end
    end
  end
end
