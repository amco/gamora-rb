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

## User authentication

To authenticate the user against the Identity Provider before each request
include `Gamora::Authentication` in your application controller and use
the before_action `authenticate_user!` in the actions you need to protect
and add the `user_authentication_failed` callback to handle when the
access token is not valid or expired. It should look like this:

```ruby
class ApplicationController < ActionController::Base
  include Gamora::Authentication
  ...

  before_action :authenticate_user!

  private

  def user_authentication_failed
    # Web-based applications will be something like this:
    redirect_to login_path, alert: "Session has expired"

    # JSON API applications something like this:
    render json: { error: "Session has expired" }, status: :unauthorized
  end
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
