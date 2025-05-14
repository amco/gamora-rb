# frozen_string_literal: true

module Gamora
  module AuthorizationUrl
    ALLOWED_PARAMS = %i[
      scope
      state
      theme
      prompt
      max_age
      strategy
      branding
      ui_locales
      allow_create
      allow_amco_badge
    ].freeze

    def authorization_url(params, extra_params = {})
      data =
        default_params
        .merge(extra_params)
        .merge(authorization_params(params))
        .compact_blank

      Client.from_config.auth_code.authorize_url(data)
    end

    private

    def default_params
      {
        scope: Configuration.default_scope,
        theme: Configuration.default_theme,
        prompt: Configuration.default_prompt,
        strategy: Configuration.default_strategy,
        branding: Configuration.default_branding,
        ui_locales: Configuration.ui_locales.call,
        allow_create: Configuration.allow_create.to_s,
        allow_amco_badge: Configuration.allow_amco_badge.to_s
      }
    end

    def authorization_params(params)
      params.permit(*ALLOWED_PARAMS)
    end
  end
end
