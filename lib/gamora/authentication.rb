# frozen_string_literal: true

module Gamora
  module Authentication
    def authenticate_user!
      source = Gamora::Configuration.access_token_source
      access_token = send(:"access_token_from_#{source}")
      validate_and_verify_access_token!(access_token)
    end

    private

    def validate_and_verify_access_token!(access_token)
      return if valid_access_token?(access_token)
      user_authentication_failed
    end

    def access_token_from_headers
      pattern = /^Bearer /
      header = request.headers["Authorization"]
      return unless header&.match(pattern)
      header.gsub(pattern, "")
    end

    def access_token_from_session
      session[:access_token]
    end

    def valid_access_token?(access_token)
      return false if access_token.blank?
      client.verify_access_token(access_token)
    end

    def client
      Client.from_config
    end
  end
end
