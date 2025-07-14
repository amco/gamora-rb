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
                  :birth_day,
                  :birth_month,
                  :phone_number,
                  :email_verified,
                  :national_id,
                  :national_id_country,
                  :associated_user_id,
                  :phone_number_verified
  end
end
