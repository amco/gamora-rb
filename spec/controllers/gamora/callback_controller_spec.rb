# frozen_string_literal: true

require "rails_helper"

module Gamora
  RSpec.describe CallbackController do
    routes { Engine.routes }

    describe "GET show" do
      let(:code) { SecureRandom.hex(10) }

      let(:request_params) do
        {
          code: code,
          grant_type: "authorization_code",
          redirect_uri: Configuration.redirect_uri
        }
      end

      let(:response_headers) do
        { "Content-Type" => "application/json" }
      end

      let(:token_url) do
        "#{Configuration.site}#{Configuration.token_url}"
      end

      context "when code is valid" do
        let(:response_body) do
          { access_token: SecureRandom.hex(10) }
        end

        before do
          stub_request(:post, token_url)
            .with(body: request_params)
            .to_return(
              body: response_body.to_json,
              headers: response_headers,
              status: 200
            )
        end

        context "when gamora.origin session key is present" do
          it "redirects to that url" do
            origin_url = "http://test.host/redirect"
            controller.session["gamora.origin"] = origin_url
            get :show, params: { code: code }
            expect(response).to be_redirect
          end
        end

        context "when gamora.origin session key is not present" do
          it "redirects to the root path" do
            root_url = "http://test.host/"
            get :show, params: { code: code }
            expect(response).to be_redirect
            expect(response).to redirect_to(root_url)
          end
        end
      end

      context "when code is not valid" do
        let(:response_body) do
          {
            error: "invalid_code",
            error_description: "Provided authorization code is incorrect."
          }
        end

        before do
          stub_request(:post, token_url)
            .with(body: request_params)
            .to_return(
              body: response_body.to_json,
              headers: response_headers,
              status: 401
            )
        end

        it "returns error description as text" do
          get :show, params: { code: code }
          expect(response.body).to include "Invalid authorization code"
        end
      end
    end
  end
end
