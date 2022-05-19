# frozen_string_literal: true

Gamora.setup do |config|
  # ===> Required OAuth2 configuration options
  config.client_id = "CLIENT_ID"
  config.client_secret = "CLIENT_SECRET"
  config.site = "IDENTITY_PROVIDER_URL"

  # ===> Optional OAuth2 configuration options and its defaults.
  # config.token_url = "/oauth2/token"
  # config.authorize_url = "/oauth2/authorize"
  # config.userinfo_url = "/oauth2/userinfo"
  # config.token_method = :post
  # config.redirect_uri = nil
  # config.default_scope = "openid profile email"
  # config.default_prompt = nil
  # config.default_strategy = "default"
  # config.ui_locales = -> { I18n.locale }
end
