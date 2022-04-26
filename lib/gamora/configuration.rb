# frozen_string_literal: true

module Gamora
  module Configuration
    mattr_accessor :client_id, default: nil
    mattr_accessor :client_secret, default: nil
    mattr_accessor :site, default: nil

    mattr_accessor :redirect_uri, default: nil
    mattr_accessor :token_url, default: "/oauth2/token"
    mattr_accessor :authorize_url, default: "/oauth2/authorize"
    mattr_accessor :introspect_url, default: "/oauth2/introspect"
    mattr_accessor :access_token_source, default: "session"
    mattr_accessor :token_method, default: :post

    def setup
      yield(self) if block_given?
    end
  end
end
