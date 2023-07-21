# frozen_string_literal: true

require "rails_helper"

RSpec.describe Gamora do
  it "has a version number" do
    expect(Gamora::VERSION).not_to be_nil
  end
end
