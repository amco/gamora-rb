# frozen_string_literal: true

Gamora.setup do |config|
  # ===> Required OAuth2 configuration options
  config.client_id = "CLIENT_ID"
  config.client_secret = "CLIENT_SECRET"
  config.site = "IDENTITY_PROVIDER"

  # ===> Optional OAuth2 configuration options and its defaults.
  # config.token_url = "/oauth/token"
  # config.authorize_url = "/openid/authorize"
  # config.introspect_url = "/oauth/introspect"
  # config.token_method = :post
  # config.redirect_uri = nil

  # ===> Authentication
  # If your application is a JSON API, you probably want to change
  # this value to "headers" to authenticate users using the access
  # token in the header Authorization: Bearer <access_token>.
  # config.access_token_source = "session"
end
