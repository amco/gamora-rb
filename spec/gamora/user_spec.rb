# frozen_string_literal: true

require "rails_helper"

RSpec.describe Gamora::User do
  describe "attributes" do
    let(:attrs) do
      {
        id: 1,
        email: "test@email.com",
        username: "foobar",
        first_name: "Foo",
        last_name: "Bar",
        birth_day: 10,
        birth_month: 10,
        phone_number: "+523344556677",
        email_verified: true,
        national_id: "XXXX123456HTCG04",
        national_id_country: "MX",
        phone_number_verified: false,
        associated_user_id: 136,
        roles: { denali: ["publisher"] }
      }
    end

    context "when contains valid attributes" do
      it "initializes user correctly" do
        expect(described_class.new(attrs))
          .to be_an_instance_of(described_class)
      end
    end

    context "when contains invalid attributes" do
      it "raises unknown attribute error" do
        expect { described_class.new(invalid: 1) }
          .to raise_error(ActiveModel::UnknownAttributeError)
      end
    end
  end
end
