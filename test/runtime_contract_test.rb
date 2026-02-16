# frozen_string_literal: true

require_relative "test_helper"
require "al_cookie"

class RuntimeContractTest < Minitest::Test
  def test_cookie_assets_are_packaged
    assert ROOT.join("lib/assets/al_cookie/js/cookie-theme-sync.js").file?
  end

  def test_cookie_tags_registered
    assert_equal AlCookie::CookieStylesTag, Liquid::Template.tags["al_cookie_styles"]
    assert_equal AlCookie::CookieScriptsTag, Liquid::Template.tags["al_cookie_scripts"]
  end

  def test_cookie_setup_template_exists
    setup_template = ROOT.join("lib/templates/cookie_consent_setup.js.liquid")
    assert setup_template.file?
    assert_includes setup_template.read, "window.CookieConsent.run"
  end
end
