# frozen_string_literal: true

module Gamora
  class User
    include ActiveModel::Model

    attr_accessor :id,
                  :roles,
                  :email,
                  :username,
                  :last_name,
                  :first_name,
                  :phone_number,
                  :email_verified,
                  :associated_user_id,
                  :phone_number_verified
  end
end
