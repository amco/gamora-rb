# frozen_string_literal: true

module Gamora
  class AuthenticationController < ApplicationController
    def show
      redirect_to authorization_url
    end

    private

    def authorization_url
      Client.from_config.auth_code.authorize_url({
        scope: Configuration.default_scope,
        prompt: Configuration.default_prompt,
        strategy: Configuration.default_strategy,
        ui_locales: Configuration.ui_locales.call
      }.merge(authorization_params).compact_blank)
    end

    def authorization_params
      params.permit(
        :scope,
        :state,
        :prompt,
        :max_age,
        :strategy,
        :ui_locales,
        :redirect_uri
      )
    end
  end
end
