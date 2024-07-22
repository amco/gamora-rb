# frozen_string_literal: true

require "rails_helper"

module Gamora
  RSpec.describe AuthenticationController do
    routes { Engine.routes }

    describe "GET show" do
      it "responses with a redirect" do
        get :show
        expect(response).to be_redirect
      end

      it "redirects to the idp" do
        get :show
        uri = URI.parse(response.location)
        expect(uri.to_s).to match "https://myidp.com/oauth2/authorize"
      end

      context "when no custom params are passed" do
        let(:expected_params) do
          {
            client_id: ["CLIENT_ID"],
            response_type: ["code"],
            scope: ["openid profile email"],
            strategy: ["default"],
            branding: ["amco"],
            theme: ["default"],
            ui_locales: ["en"],
            allow_create: ["true"],
            redirect_uri: ["http://localhost:3000"]
          }
        end

        it "redirects to the idp with the default query params" do
          get :show
          uri = URI.parse(response.location)
          query_params = CGI.parse(uri.query).symbolize_keys
          expect(query_params).to eql expected_params
        end
      end

      context "when custom params are passed" do
        let(:params) do
          {
            state: "state",
            scope: "openid",
            theme: "default",
            prompt: "login",
            max_age: "100000",
            strategy: "custom",
            branding: "avanza",
            ui_locales: "es-MX",
            allow_create: "false"
          }
        end

        let(:expected_params) do
          {
            state: [params[:state]],
            scope: [params[:scope]],
            theme: [params[:theme]],
            prompt: [params[:prompt]],
            max_age: [params[:max_age]],
            strategy: [params[:strategy]],
            branding: [params[:branding]],
            ui_locales: [params[:ui_locales]],
            allow_create: [params[:allow_create]]
          }
        end

        it "redirects to the idp with custom query params" do
          get :show, params: params
          uri = URI.parse(response.location)
          query_params = CGI.parse(uri.query).symbolize_keys
          expect(query_params).to include expected_params
        end
      end

      context "when application has custom locale" do
        before { I18n.locale = :fr }

        it "redirects to the idp with current locale" do
          get :show
          uri = URI.parse(response.location)
          query_params = CGI.parse(uri.query).symbolize_keys
          expect(query_params[:ui_locales]).to eql ["fr"]
        end
      end

      context "when redirect_uri is nil" do
        before do
          allow(Configuration).to receive(:redirect_uri).and_return(nil)
        end

        it "redirects without redirect_uri param" do
          get :show
          uri = URI.parse(response.location)
          query_params = CGI.parse(uri.query).symbolize_keys
          expect(query_params.keys).not_to include :redirect_uri
        end
      end
    end
  end
end
