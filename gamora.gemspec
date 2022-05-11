# frozen_string_literal: true

require_relative "lib/gamora/version"

Gem::Specification.new do |spec|
  spec.name        = "gamora"
  spec.version     = Gamora::VERSION
  spec.authors     = ["Alejandro Gutiérrez"]
  spec.email       = ["alejandrodevs@gmail.com"]
  spec.homepage    = "https://github.com/amco/gamora_rb"
  spec.summary     = "OpenID Connect Relying Party for rails apps."
  spec.description = "Gamora aims to provide most of the functionality that is commonly required in an OIDC Client."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "oauth2", "~> 1.4"
  spec.add_dependency "rails", ">= 6.0"
end
