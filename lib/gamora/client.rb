# frozen_string_literal: true

module Gamora
  class Client < OAuth2::Client
    class << self
      def from_config
        new(
          Configuration.client_id,
          Configuration.client_secret,
          client_options
        )
      end

      private

      def client_options
        {
          site: Configuration.site,
          token_url: Configuration.token_url,
          token_method: Configuration.token_method,
          redirect_uri: Configuration.redirect_uri,
          userinfo_url: Configuration.userinfo_url,
          authorize_url: Configuration.authorize_url,
          introspect_url: Configuration.introspect_url
        }
      end
    end

    def userinfo(access_token)
      params = userinfo_params(access_token)
      opts = request_options(params)
      response = request(:post, options[:userinfo_url], opts)
      JSON.parse(response.body).symbolize_keys
    rescue OAuth2::Error
      {}
    end

    def introspect(access_token)
      params = introspect_params(access_token)
      opts = request_options(params)
      response = request(:post, options[:introspect_url], opts)
      JSON.parse(response.body).symbolize_keys
    rescue OAuth2::Error
      {}
    end

    private

    def request_options(params)
      {
        body: params.to_json,
        headers: { "Content-Type": "application/json" }
      }
    end

    def userinfo_params(access_token)
      { access_token: access_token }
    end

    def introspect_params(access_token)
      {
        token: access_token,
        client_id: Configuration.client_id,
        client_secret: Configuration.client_secret
      }
    end
  end
end
