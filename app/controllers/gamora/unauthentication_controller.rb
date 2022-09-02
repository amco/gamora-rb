# frozen_string_literal: true

module Gamora
  class UnauthenticationController < ApplicationController
    include AuthorizationUrl

    def show
      session[:access_token] = nil

      redirect_to authorization_url(params, { max_age: 0 }),
        allow_other_host: true,
        status: :see_other
    end
  end
end
