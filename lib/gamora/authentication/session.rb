# frozen_string_literal: true

module Gamora
  module Authentication
    module Session
      include Base

      def self.included(base)
        base.helper_method :current_user
      end

      private

      def access_token
        session[:access_token]
      end

      def authentication_failed!
        session["gamora.origin"] = request.original_url
        redirect_to gamora.authentication_path
      end
    end
  end
end
