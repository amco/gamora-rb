# frozen_string_literal: true

require "spec_helper"

module Gamora
  RSpec.describe Client do
    describe ".from_config" do
      it "generates client based on the config" do
        client = described_class.from_config

        expect(client).to be_an_instance_of(described_class)
        expect(client.id).to eql Configuration.client_id
        expect(client.site).to eql Configuration.site
        expect(client.secret).to eql Configuration.client_secret
      end

      it "client has correct options" do
        client = described_class.from_config

        expect(client.options).to include(
          {
            token_url: Configuration.token_url,
            token_method: Configuration.token_method,
            redirect_uri: Configuration.redirect_uri,
            authorize_url: Configuration.authorize_url,
            introspect_url: Configuration.introspect_url
          }
        )
      end
    end

    describe "#access_token_active?" do
      let(:access_token) { SecureRandom.hex(10) }

      let(:request_params) do
        {
          token: access_token,
          client_id: Configuration.client_id,
          client_secret: Configuration.client_secret
        }
      end

      let(:request_headers) do
        { "Content-Type": "application/json" }
      end

      let(:introspect_url) do
        "#{Configuration.site}#{Configuration.introspect_url}"
      end

      subject { described_class.from_config }

      before do
        Configuration.site = "https://idp.example.com"

        stub_request(:post, introspect_url)
          .with(body: request_params, headers: request_headers)
          .to_return(body: response_body.to_json, status: response_status)
      end

      context "when it is active" do
        let(:response_body) { { active: true } }
        let(:response_status) { 200 }

        it "returns true" do
          expect(subject.access_token_active?(access_token)).to be true
        end
      end

      context "when it is inactive" do
        let(:response_body) { { active: false } }
        let(:response_status) { 200 }

        it "returns false" do
          expect(subject.access_token_active?(access_token)).to be false
        end
      end
    end
  end
end
