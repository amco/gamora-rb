# frozen_string_literal: true

module Gamora
  class User
    include ActiveModel::Model

    attr_accessor :id,
                  :roles,
                  :email,
                  :last_name,
                  :first_name,
                  :phone_number,
                  :email_verified,
                  :phone_number_verified
  end
end
