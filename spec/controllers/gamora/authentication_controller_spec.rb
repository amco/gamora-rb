# frozen_string_literal: true

require "rails_helper"

RSpec.describe Gamora::AuthenticationController do
  routes { Gamora::Engine.routes }

  describe "GET show" do
    it "redirects to the idp" do
      get :show
      uri = URI.parse(response.location)
      expect(response).to be_redirect
      expect(uri.port).to eql 443
      expect(uri.host).to eql "myidp.com"
      expect(uri.path).to eql Gamora::Configuration.authorize_url
    end

    it "redirects to the idp with the default query params" do
      get :show
      uri = URI.parse(response.location)
      query_params = CGI.parse(uri.query).symbolize_keys
      expect(query_params[:client_id]).to eql ["CLIENT_ID"]
      expect(query_params[:response_type]).to eql ["code"]
      expect(query_params[:scope]).to eql ["openid profile email"]
      expect(query_params[:strategy]).to eql ["default"]
      expect(query_params[:ui_locales]).to eql ["en"]
      expect(query_params[:redirect_uri]).to eql ["http://localhost:3000"]
    end

    context "when custom params are passed" do
      let(:params) do
        {
          state: "state",
          scope: "openid",
          prompt: "login",
          max_age: "100000",
          strategy: "custom",
          ui_locales: "es-MX",
        }
      end

      it "redirects to the idp with custom query params" do
        get :show, params: params
        uri = URI.parse(response.location)
        query_params = CGI.parse(uri.query).symbolize_keys
        expect(query_params[:state]).to eql [params[:state]]
        expect(query_params[:scope]).to eql [params[:scope]]
        expect(query_params[:prompt]).to eql [params[:prompt]]
        expect(query_params[:max_age]).to eql [params[:max_age]]
        expect(query_params[:strategy]).to eql [params[:strategy]]
        expect(query_params[:ui_locales]).to eql [params[:ui_locales]]
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
      before { Gamora::Configuration.redirect_uri = nil }

      it "redirects without redirect_uri param" do
        get :show
        uri = URI.parse(response.location)
        query_params = CGI.parse(uri.query).symbolize_keys
        expect(query_params.keys).to_not include :redirect_uri
      end
    end
  end
end
