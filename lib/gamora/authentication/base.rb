# frozen_string_literal: true

module Gamora
  module Authentication
    module Base
      CLAIMS = {
        sub: :id,
        roles: :roles,
        email: :email,
        given_name: :first_name,
        family_name: :last_name,
        phone_number: :phone_number,
        email_verified: :email_verified,
        phone_number_verified: :phone_number_verified
      }.freeze

      def authenticate_user!
        claims = resource_owner_claims(access_token)
        assign_current_user_from_claims(claims) if claims.present?
        validate_authentication!
      end

      def current_user
        @current_user
      end

      private

      def validate_authentication!
        raise NotImplementedError
      end

      def access_token
        raise NotImplementedError
      end

      def user_authentication_failed!
        raise NotImplementedError
      end

      def assign_current_user_from_claims(claims)
        attrs = user_attributes_from_claims(claims)
        @current_user = User.new(attrs)
      end

      def user_attributes_from_claims(claims)
        claims.slice(*CLAIMS.keys).transform_keys(CLAIMS)
      end

      def resource_owner_claims(access_token)
        return {} if access_token.blank?

        resource_owner_claims!(access_token)
      end

      def resource_owner_claims!(access_token)
        Rails.cache.fetch(cache_key(access_token), cache_options) do
          oauth_client.userinfo(access_token)
        end
      end

      def oauth_client
        Client.from_config
      end

      def cache_options
        { expires_in: Configuration.userinfo_cache_expires_in }
      end

      def cache_key(access_token)
        "userinfo:#{Digest::SHA256.hexdigest(access_token)}"
      end
    end
  end
end
