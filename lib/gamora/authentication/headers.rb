# frozen_string_literal: true

module Gamora
  module Authentication
    module Headers
      include Base

      private

      def validate_authentication!
        return if current_user.present?
        user_authentication_failed!
      end

      def access_token
        pattern = /^Bearer /
        header = request.headers["Authorization"]
        return unless header&.match(pattern)
        header.gsub(pattern, "")
      end

      def user_authentication_failed!
        render json: { error: "Access token invalid" }, status: :unauthorized
      end
    end
  end
end
