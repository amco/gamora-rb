# frozen_string_literal: true

require "oauth2"
require "gamora/version"
require "gamora/engine"
require "gamora/configuration"

module Gamora
  extend Configuration

  autoload :User, "gamora/user"
  autoload :Client, "gamora/client"
  autoload :Authentication, "gamora/authentication"
end
