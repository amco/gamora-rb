# frozen_string_literal: true

module Gamora
  class AuthenticationController < ApplicationController
    include AuthorizationUrl

    def show
      redirect_to authorization_url(params),
        allow_other_host: true,
        status: :see_other
    end
  end
end
