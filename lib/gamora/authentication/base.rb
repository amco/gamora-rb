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
        token_data[:active] && whitelisted_client?(token_data[:client_id])
      end

      def whitelisted_client?(client_id)
        whitelisted_clients.include?(client_id)
      end

      def whitelisted_clients
        Configuration.cross_client_whitelist | [Configuration.client_id]
      end

      def assign_current_user_from_claims(claims)
        attrs = user_attributes_from_claims(claims)
        @current_user = User.new(attrs)
      end

      def user_attributes_from_claims(claims)
        claims.slice(*CLAIMS.keys).transform_keys(CLAIMS)
      end

      def resource_owner_claims(access_token)
        cache_key = cache_key(:userinfo, access_token)
        cache_options = { expires_in: Configuration.userinfo_cache_expires_in }

        Rails.cache.fetch(cache_key, cache_options) do
          oauth_client.userinfo(access_token)
        end
      end

      def introspect_access_token(access_token)
        cache_key = cache_key(:introspect, access_token)
        cache_options = { expires_in: Configuration.introspect_cache_expires_in }

        Rails.cache.fetch(cache_key, cache_options) do
          oauth_client.introspect(access_token)
        end
      end

      def oauth_client
        Client.from_config
      end

      def cache_key(context, access_token)
        "#{context}:#{Digest::SHA256.hexdigest(access_token)}"
      end
    end
  end
end
