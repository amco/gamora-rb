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

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
