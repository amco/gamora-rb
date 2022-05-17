# frozen_string_literal: true

module Gamora
  module Authentication
    def self.included(base)
      base.helper_method :current_user
    end

    def authenticate_user!
      source = Gamora::Configuration.access_token_source
      access_token = send(:"access_token_from_#{source}")
      claims = resource_owner_claims(access_token)
      assign_current_user_from_claims(claims) if claims.present?
      validate_authentication!
    end

    def current_user
      @current_user
    end

    private

    def validate_authentication!
      unless current_user.present?
        user_authentication_failed!
      end
    end

    def assign_current_user_from_claims(claims)
      attrs = user_attributes_from_claims(claims)
      @current_user = User.new(attrs)
    end

    def user_attributes_from_claims(claims)
      claims.transform_keys do |key|
        case key
        when :sub then :id
        when :email then :email
        when :given_name then :first_name
        when :family_name then :last_name
        when :phone_number then :phone_number
        else key
        end
      end
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

    def resource_owner_claims(access_token)
      return {} if access_token.blank?
      client.userinfo(access_token)
    end

    def client
      Client.from_config
    end
  end
end
