# frozen_string_literal: true

module Gamora
  module Authentication
    module Base
      CLAIMS = {
        sub: :id,
        roles: :roles,
        email: :email,
        username: :username,
        given_name: :first_name,
        family_name: :last_name,
        phone_number: :phone_number,
        email_verified: :email_verified,
        phone_number_verified: :phone_number_verified
      }.freeze

      def authenticate_user!
        return authentication_failed! unless access_token.present?

        token_data = introspect_access_token(access_token)
        return authentication_failed! unless valid_token_data?(token_data)

        claims = resource_owner_claims(access_token)
        return authentication_failed! unless claims.present?

        assign_current_user_from_claims(claims)
      end

      def current_user
        @current_user
      end

      private

      def access_token
        raise NotImplementedError
      end

      def authentication_failed!
        raise NotImplementedError
      end

      def valid_token_data?(token_data)
        token_data[:active]
      end

      def assign_current_user_from_claims(claims)
        attributes = user_attributes_from_claims(claims)
        @current_user = User.new(attributes)
      end

      def user_attributes_from_claims(claims)
        claims.slice(*CLAIMS.keys).transform_keys(CLAIMS)
      end

      def resource_owner_claims(access_token)
        cache_key = cache_key(:userinfo, access_token)
        expires_in = Configuration.userinfo_cache_expires_in

        Rails.cache.fetch(cache_key, { expires_in: expires_in }) do
          oauth_client.userinfo(access_token)
        end
      end

      def introspect_access_token(access_token)
        cache_key = cache_key(:introspect, access_token)
        expires_in = Configuration.introspect_cache_expires_in

        Rails.cache.fetch(cache_key, { expires_in: expires_in }) do
          oauth_client.introspect(access_token)
        end
      end

      def cache_key(context, access_token)
        "gamora:#{context}:#{Digest::SHA256.hexdigest(access_token)}"
      end

      def oauth_client
        Client.from_config
      end
    end
  end
end
