module Gamora
  module AuthorizationUrl
    def authorization_url(params, extra_params = {})
      default_params = {
        scope: Configuration.default_scope,
        theme: Configuration.default_theme,
        prompt: Configuration.default_prompt,
        strategy: Configuration.default_strategy,
        branding: Configuration.default_branding,
        ui_locales: Configuration.ui_locales.call
      }

      data =
        default_params.
        merge(extra_params).
        merge(authorization_params(params)).
        compact_blank

      Client.from_config.auth_code.authorize_url(data)
    end

    private

    def authorization_params(params)
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
