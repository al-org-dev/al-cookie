# Changelog

## 1.0.1 — 2026-08-02

- Fix: the cookie-consent runtime was published to `/lib/assets/al_cookie/js/` while the script tag pointed at
  `/assets/al_cookie/js/`, so it 404'd on every site with `enable_cookie_consent: true`. Only the default-off state
  hid it.

## Unreleased

- Initial extraction of cookie consent runtime from `al_folio_core` into `al_cookie`.
