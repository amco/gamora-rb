# frozen_string_literal: true

module Gamora
  module Authentication
    module Base
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
