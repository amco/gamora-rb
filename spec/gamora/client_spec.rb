# frozen_string_literal: true

require "rails_helper"

module Gamora
  RSpec.describe Client do
    describe ".from_config" do
      let(:options) do
        {
          token_url: Configuration.token_url,
          token_method: Configuration.token_method,
          redirect_uri: Configuration.redirect_uri,
          userinfo_url: Configuration.userinfo_url,
          authorize_url: Configuration.authorize_url,
          introspect_url: Configuration.introspect_url
        }
      end

      it "generates client based on the config" do
        client = described_class.from_config
        expect(client).to be_an_instance_of(described_class)
      end

      it "includes client id in the config" do
        client = described_class.from_config
        expect(client.id).to eql Configuration.client_id
      end

      it "includes idp site in the config" do
        client = described_class.from_config
        expect(client.site).to eql Configuration.site
      end

      it "includes client secret in the config" do
        client = described_class.from_config
        expect(client.secret).to eql Configuration.client_secret
      end

      it "has correct options" do
        client = described_class.from_config
        expect(client.options).to include options
      end
    end

    describe "#userinfo" do
      subject(:client) { described_class.from_config }

      let(:access_token) { SecureRandom.hex(10) }

      let(:request_params) do
        { access_token: access_token }
      end

      let(:userinfo_url) do
        "#{Configuration.site}#{Configuration.userinfo_url}"
      end

      before do
        Configuration.site = "https://idp.example.com"

        stub_request(:post, userinfo_url)
          .with(body: request_params)
          .to_return(body: response_body.to_json, status: response_status)
      end

      context "when access token is valid" do
        let(:response_body) { { email: "test@example.com" } }
        let(:response_status) { 200 }

        it "returns claims" do
          expect(client.userinfo(access_token)).to eql response_body
        end
      end

      context "when access token is invalid" do
        let(:response_body) { "" }
        let(:response_status) { 401 }

        it "returns empty hash" do
          expect(client.userinfo(access_token)).to eql({})
        end
      end
    end

    describe "#introspect" do
      subject(:client) { described_class.from_config }

      let(:access_token) { SecureRandom.hex(10) }

      let(:request_params) do
        {
          token: access_token,
          client_id: Configuration.client_id,
          client_secret: Configuration.client_secret
        }
      end

      let(:introspect_url) do
        "#{Configuration.site}#{Configuration.introspect_url}"
      end

      before do
        Configuration.site = "https://idp.example.com"

        stub_request(:post, introspect_url)
          .with(body: request_params)
          .to_return(body: response_body.to_json, status: response_status)
      end

      context "when response is valid" do
        let(:response_body) { { active: true } }
        let(:response_status) { 200 }

        it "returns claims" do
          expect(client.introspect(access_token)).to eql response_body
        end
      end

      context "when response is invalid" do
        let(:response_body) { "" }
        let(:response_status) { 401 }

        it "returns empty hash" do
          expect(client.introspect(access_token)).to eql({})
        end
      end
    end
  end
end
