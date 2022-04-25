# frozen_string_literal: true

module Gamora
  module Configuration
    mattr_accessor :client_id
    @@client_id = nil

    mattr_accessor :client_secret
    @@client_secret = nil

    mattr_accessor :site
    @@site = nil

    mattr_accessor :token_url
    @@token_url = "/oauth/token"

    mattr_accessor :authorize_url
    @@authorize_url = "/openid/authorize"

    mattr_accessor :introspect_url
    @@introspect_url = "/oauth/introspect"

    mattr_accessor :token_method
    @@token_method = :post

    mattr_accessor :redirect_uri
    @@redirect_uri = nil

    mattr_accessor :access_token_source
    @@access_token_source = "session"

    def setup
      yield(self) if block_given?
    end
  end
end
