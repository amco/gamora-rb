# Changelog

## [0.17.0] - 2025-07-14

- Enhancements:
  - Add support for `birth_day`, `birth_month`, `national_id` and `national_id_country` claims.

## [0.16.0] - 2025-07-04

- Enhancements:
  - Add support for `sp` (Service provider) param in the authorization url.

## [0.15.0] - 2025-05-14

- Enhancements:
  - Add support for `allow_amco_badge` param in the authorization url.

## [0.14.1] - 2025-04-03

- Enhancements:
  - Remove ActiveRecord dependency.

## [0.14.0] - 2024-11-14

- Enhancements:
  - Add support for `associated_user_id` claim.

## [0.13.0] - 2024-10-09

- Features:
  - Add authorized endpoint in order to inform if the user is granted to
    access the IDP client.

## [0.12.0] - 2024-07-22

- Enhancements:
  - Add support for `allow_create` param in the authorization url.

## [0.11.0] - 2024-02-21

- Deprecations:
  - Remove `whitelisted_clients` support.

## [0.10.0] - 2023-12-21

- Enhancements:
  - Add support for `username` claim.

## [0.9.0] - 2023-11-24

- Enhancements:
  - Verify access token using introspect endpoint instead userinfo.
  - Add `introspect_cache_expires_in` config to avoid hitting the IDP
    every request. Default value is `0.seconds`.
  - New default value for `userinfo_cache_expires_in` config. Now,
    the default value is `1.minute`.
  - Add `whitelisted_clients` config to accept access tokens ONLY
    from trusted clients. Default value is the same client.

- Breaking changes:
  - If your application is accepting access tokens from other IDP
    clients you must set the `whitelisted_clients` config with
    the client ids that are whitelisted. Otherwise, the application
    is gonna accept access tokens ONLY from the same client id.

## [0.8.0] - 2023-11-21

- Enhancements:
  - Add support for `roles` claim.

## [0.7.0] - 2023-11-02

- Enhancements:
  - Add support for `email_verified` and `phone_number_verified` claims.

## [0.6.1] - 2023-07-21

- Enhancements:
  - Improve gem strucure and fix rubocop warnings.

## [0.6.0] - 2023-01-11

- Enhancements:
  - Allow oauth versions greater than 2.0.

## [0.5.0] - 2022-09-05

- Enhancements:
  - Add `userinfo_cache_expires_in` config to avoid hitting the IDP
    every request. (Default set to 0.seconds)

## [0.4.0] - 2022-09-02

- Features:
  - Add logout endpoint to remove access/refresh tokens and get redirected
    to the IDP again.

## [0.3.0] - 2022-08-04

- Enhancements:
  - Add support for `branding` param in the authorization url.

## [0.2.0] - 2022-07-28

- Enhancements:
  - Add support for `theme` param in the authorization url.

## [0.1.0] - 2022-05-20

- Initial release
