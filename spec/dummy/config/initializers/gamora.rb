# frozen_string_literal: true

Gamora.setup do |config|
  # ===> Required OAuth2 configuration options
  config.client_id = "CLIENT_ID"
  config.client_secret = "CLIENT_SECRET"
  config.site = "https://myidp.com"

  # ===> Optional OAuth2 configuration options and its defaults.
  # config.token_url = "/oauth2/token"
  # config.userinfo_url = "/oauth2/userinfo"
  # config.authorize_url = "/oauth2/authorize"
  # config.introspect_url = "/oauth2/introspect"
  # config.token_method = :post
  config.redirect_uri = "http://localhost:3000"
  # config.default_scope = "openid profile email"
  # config.default_prompt = nil
  # config.default_strategy = "default"
  # config.default_branding = "amco"
  # config.default_theme = "default"
  # config.ui_locales = -> { I18n.locale }
  # config.userinfo_cache_expires_in = 0.seconds
  # config.introspect_cache_expires_in = 0.seconds
  # config.whitelisted_clients = []
end
