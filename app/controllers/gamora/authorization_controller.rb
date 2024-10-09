# frozen_string_literal: true

module Gamora
  class AuthorizationController < ApplicationController
    include Gamora::Authentication::Headers

    before_action :authenticate_user!

    def show
      Configuration.authorization_method.call(current_user) ?
        render(json: { message: "Authorized user" }, status: :ok) :
        render(json: { error: "Unauthorized user" }, status: :forbidden)
    end
  end
end
