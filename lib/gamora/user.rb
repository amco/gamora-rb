# frozen_string_literal: true

module Gamora
  class User
    include ActiveModel::Model

    attr_accessor :id,
                  :email,
                  :last_name,
                  :first_name,
                  :phone_number
  end
end
