# Gamora - OIDC Relying Party

Gamora aims to provide most of the functionality that is commonly
required in an OpenID Connect Relying Party. An OIDC Relying Party is
an OAuth 2.0 Client application that requires user authentication and
claims from an OpenID Connect Provider (IdP). More information about
[OpenID Connect](https://openid.net/connect/).

## Installation

Add `Gamora` to your application's Gemfile:

```ruby
gem "gamora"
```

And then install gamora:

```bash
rails g gamora:install
```

## Configuration

Provide required configuration in `config/initializers/gamora.rb`:

```ruby
Gamora.setup do |config|
  # ===> Required OAuth2 configuration options
  config.client_id = "CLIENT_ID"
  config.client_secret = "CLIENT_SECRET"
  config.site = "IDENTITY_PROVIDER"

  ...
end
```

To see the full list of configuration options please check your gamora
initializer.

## Mount Gamora Engine

In order to have the authorization and callback endpoints mount the
engine in the `config/routes.rb` file:

```ruby
Rails.application.routes.draw do
  ...
  mount Gamora::Engine => "/auth"

  ...
end
```

This will enable the following routes in the parent application:

#### `gamora.authorization_path`

This endpoint will redirect users to the IDP generating url and query
params based on the configuration. This endpoint is called automatically
when the user is not logged in and the application requires users to be
authenticated.

#### `gamora.logout_path`

This endpoint allows users to be logged out from the application and the
IDP. It removes the access and refresh tokens and redirects to IDP in order
to force users to authenticate again.

#### `gamora.callback_path`

This endpoint is the responsible to received the auth code provided by
the IDP and generate and access token. This endpoint is called automatically
once the user authenticates successfully in the IDP.

## User authentication

### Web-based applications

To authenticate the user against the Identity Provider before each request
using an access token stored in the session you should include
`Gamora::Authentication::Session` in your application controller and use the
before_action `authenticate_user!` in the actions you need to protect.
In case the access token has expired or is invalid. it will redirect the
user to the IdP to authenticate again.

```ruby
class ApplicationController < ActionController::Base
  include Gamora::Authentication::Session
  ...

  before_action :authenticate_user!
end
```

### JSON API applications

In the other hand, if your application is an JSON API you probably want
to authenticate the user using the access token in the request headers.
To do that, you should include `Gamora::Authentication::Headers` in your
application controller and use the before_action `authenticate_user!` in
the actions you need to protect. In case the access token has expired or
is invalid. it will return an error json with unauthorized status.

```ruby
class ApplicationController < ActionController::Base
  include Gamora::Authentication::Headers
  ...

  before_action :authenticate_user!
end
```

Optionally, if you want to do something different when authentication
fails, you just need to override the `user_authentication_failed!`
method in you controller and customize it as you wish.

## Caching

In order to avoid performing requests to the IDP on each request in the
application, it is possible to set a caching time for introspection and
userinfo endpoints. Make sure to not have a too long expiration time for
`introspect_cache_expires_in` but not too short to impact the application
performance, it is a balance.

```ruby
Gamora.setup do |config|
  ...

  config.userinfo_cache_expires_in = 10.minute
  config.introspect_cache_expires_in = 5.seconds
end
```

## Authorization

In order to inform if a user's access token is granted to access the IDP
client, it is possible to configure the authorization method in the initializer
that will be used in the `/auth/amco/authorized` endpoint.

```ruby
Gamora.setup do |config|
  ...

  config.authorization_method = -> (user) { MyAuthorizationService.call(user) }
end
```

Then implement the `MyAuthorizationService` based on your needs and return
true if the user is granted, otherwise return false.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and
then run `bundle exec rake release`, which will create a git tag for the
version, push git commits and the created tag, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amco/gamora-rb.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[code of conduct](https://github.com/amco/gamora-rb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Gamora project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/amco/gamora-rb/blob/main/CODE_OF_CONDUCT.md).
