# frozen_string_literal: true

require "rails_helper"

RSpec.describe HomeController do
  describe "GET index" do
    context "when user is logged in" do
      let(:access_token) { SecureRandom.hex(10) }
      let(:request_params) { { access_token: access_token } }
      let(:response_body) { { id: 10  } }
      let(:response_status) { 200 }

      let(:userinfo_url) do
        "#{Gamora::Configuration.site}#{Gamora::Configuration.userinfo_url}"
      end

      before do
        session[:access_token] = access_token
      end

      context "when userinfo is cached" do
        before do
          Gamora::Configuration.userinfo_cache_expires_in = 2.seconds

          Rails.cache.write(
            "userinfo:#{Digest::SHA256.hexdigest(access_token)}", { id: 10 },
            expires_in: Gamora::Configuration.userinfo_cache_expires_in)
        end

        context "when cache has not expired" do
          it "does not make a request to the idp" do
            get :index
            expect(response).to be_successful
            expect(WebMock).to_not have_requested(:post, userinfo_url)
          end
        end

        context "when cache has expired" do
          before do
            sleep Gamora::Configuration.userinfo_cache_expires_in

            stub_request(:post, userinfo_url)
              .with(body: request_params)
              .to_return(body: response_body.to_json, status: response_status)
          end

          it "makes a request to the idp" do
            get :index
            expect(response).to be_successful
            expect(WebMock).to have_requested(:post, userinfo_url).once
          end
        end
      end

      context "when userinfo is not cached" do
        before do
          stub_request(:post, userinfo_url)
            .with(body: request_params)
            .to_return(body: response_body.to_json, status: response_status)
        end

        it "makes a request to the idp" do
          get :index
          expect(response).to be_successful
          expect(WebMock).to have_requested(:post, userinfo_url).once
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to the idp" do
        get :index
        expect(response).to be_redirect
      end
    end
  end
end
