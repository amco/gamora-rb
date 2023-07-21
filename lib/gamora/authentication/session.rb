# frozen_string_literal: true

module Gamora
  module Authentication
    module Session
      include Base

      def self.included(base)
        base.helper_method :current_user
      end

      private

      def validate_authentication!
        return if current_user.present?

        session["gamora.origin"] = request.original_url
        user_authentication_failed!
      end

      def access_token
        session[:access_token]
      end

      def user_authentication_failed!
        redirect_to gamora.authentication_path
      end
    end
  end
end
