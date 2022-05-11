# frozen_string_literal: true

module Gamora
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Creates gamora initializer."

      def create_initializer
        template "gamora.rb", "config/initializers/gamora.rb"
      end
    end
  end
end
