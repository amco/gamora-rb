# frozen_string_literal: true

module Gamora
  class AuthenticationController < ApplicationController
    def show
      redirect_to authorization_url, allow_other_host: true
    end

    private

    def authorization_url
      Client.from_config.auth_code.authorize_url({
        scope: Configuration.default_scope,
        theme: Configuration.default_theme,
        prompt: Configuration.default_prompt,
        strategy: Configuration.default_strategy,
        branding: Configuration.default_branding,
        ui_locales: Configuration.ui_locales.call
      }.merge(authorization_params).compact_blank)
    end

    def authorization_params
      params.permit(
        :scope,
        :state,
        :theme,
        :prompt,
        :max_age,
        :strategy,
        :branding,
        :ui_locales
      )
    end
  end
end
