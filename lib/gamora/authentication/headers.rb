# frozen_string_literal: true

module Gamora
  module Authentication
    module Headers
      include Base

      private

      def access_token
        pattern = /^Bearer /
        header = request.headers["Authorization"]
        return unless header&.match(pattern)

        header.gsub(pattern, "")
      end

      def authentication_failed!
        render json: { error: "Access token invalid" }, status: :unauthorized
      end
    end
  end
end
