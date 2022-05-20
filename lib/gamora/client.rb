# frozen_string_literal: true

module Gamora
  class Client < OAuth2::Client
    def self.from_config
      new(
        Configuration.client_id,
        Configuration.client_secret,
        {
          site: Configuration.site,
          token_url: Configuration.token_url,
          token_method: Configuration.token_method,
          redirect_uri: Configuration.redirect_uri,
          userinfo_url: Configuration.userinfo_url,
          authorize_url: Configuration.authorize_url
        }
      )
    end

    def userinfo(access_token)
      response = userinfo_request(access_token)
      JSON.parse(response.body).symbolize_keys
    rescue OAuth2::Error
      {}
    end

    private

    def userinfo_request(access_token)
      opts = userinfo_request_options(access_token)
      request(:post, options[:userinfo_url], opts)
    end

    def userinfo_request_options(access_token)
      {
        body: { access_token: access_token }.to_json,
        headers: { "Content-Type": "application/json" }
      }
    end
  end
end
