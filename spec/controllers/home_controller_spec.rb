# frozen_string_literal: true

require "rails_helper"

RSpec.describe HomeController do
  describe "GET index" do
    context "when user is logged in" do
      let(:site)            { Gamora::Configuration.site }
      let(:userinfo_path)   { Gamora::Configuration.userinfo_url }
      let(:introspect_path) { Gamora::Configuration.introspect_url }
      let(:userinfo_url)    { "#{site}#{userinfo_path}" }
      let(:introspect_url)  { "#{site}#{introspect_path}" }
      let(:access_token)    { SecureRandom.hex(10) }
      let(:digest_token)    { Digest::SHA256.hexdigest(access_token) }

      let(:userinfo_params) do
        { access_token: access_token }
      end

      let(:userinfo_response) do
        {
          id: 10,
          roles: {},
          given_name: "Foo",
          family_name: "Bar",
          email: "test@example.com",
          email_verified: true,
          phone_number: "+523344556677",
          phone_number_verified: true
        }
      end

      let(:introspect_params) do
        {
          token: access_token,
          client_id: Gamora::Configuration.client_id,
          client_secret: Gamora::Configuration.client_secret
        }
      end

      let(:introspect_response) do
        {
          active: true,
          client_id: Gamora::Configuration.client_id
        }
      end

      before do
        session[:access_token] = access_token
      end

      context "when introspect and userinfo is cached" do
        before do
          Gamora::Configuration.userinfo_cache_expires_in = 2.seconds
          Gamora::Configuration.introspect_cache_expires_in = 2.seconds

          Rails.cache.write(
            "gamora:userinfo:#{digest_token}", userinfo_response,
            expires_in: Gamora::Configuration.userinfo_cache_expires_in
          )

          Rails.cache.write(
            "gamora:introspect:#{digest_token}", introspect_response,
            expires_in: Gamora::Configuration.introspect_cache_expires_in
          )
        end

        it "responses successfully" do
          get :index
          expect(response).to be_successful
        end

        it "does not request userinfo to the idp" do
          get :index
          expect(WebMock).not_to have_requested(:post, userinfo_url)
        end

        it "does not request introspect to the idp" do
          get :index
          expect(WebMock).not_to have_requested(:post, introspect_url)
        end
      end

      context "when introspect and userinfo caches have expired" do
        before do
          Gamora::Configuration.introspect_cache_expires_in = 0.seconds
          Gamora::Configuration.userinfo_cache_expires_in = 0.seconds

          Rails.cache.write(
            "gamora:userinfo:#{digest_token}", userinfo_response,
            expires_in: Gamora::Configuration.userinfo_cache_expires_in
          )

          Rails.cache.write(
            "gamora:introspect:#{digest_token}", introspect_response,
            expires_in: Gamora::Configuration.introspect_cache_expires_in
          )

          stub_request(:post, userinfo_url)
            .with(body: userinfo_params)
            .to_return(body: userinfo_response.to_json, status: 200)

          stub_request(:post, introspect_url)
            .with(body: introspect_params)
            .to_return(body: introspect_response.to_json, status: 200)
        end

        it "responses successfully" do
          get :index
          expect(response).to be_successful
        end

        it "requests userinfo to the idp" do
          get :index
          expect(WebMock).to have_requested(:post, userinfo_url).once
        end

        it "requests introspect to the idp" do
          get :index
          expect(WebMock).to have_requested(:post, introspect_url).once
        end
      end

      context "when introspect and userinfo are not cached" do
        before do
          stub_request(:post, userinfo_url)
            .with(body: userinfo_params)
            .to_return(body: userinfo_response.to_json, status: 200)

          stub_request(:post, introspect_url)
            .with(body: introspect_params)
            .to_return(body: introspect_response.to_json, status: 200)
        end

        it "responses successfully" do
          get :index
          expect(response).to be_successful
        end

        it "requests userinfo to the idp" do
          get :index
          expect(WebMock).to have_requested(:post, userinfo_url).once
        end

        it "requests introspect to the idp" do
          get :index
          expect(WebMock).to have_requested(:post, introspect_url).once
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
