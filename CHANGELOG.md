# Changelog

## [0.9.0] - 2023-11-24

- Enhancements:
  - Verify access token using introspect endpoint instead userinfo.
  - Add `introspect_cache_expires_in` config to avoid hitting the IDP
    every request. Default value set to 0.seconds.
  - Change default value for `userinfo_cache_expires_in` config. Now,
    the default set to 1.minute.
  - Add `cross_client_whitelist` config to accept access tokens only
    from trusted clients. Default value set to same client.

- Breaking changes:
  - If your application is accepting access tokens from other IDP
    clients you must set the config `cross_client_whitelist` with
    the client ids that are valid.

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
