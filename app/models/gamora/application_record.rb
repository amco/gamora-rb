# frozen_string_literal: true

module Gamora
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
