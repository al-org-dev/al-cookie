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

  # --- regression: the runtime must land where the tag points --------------

  def test_runtime_is_published_under_slash_assets
    # Jekyll writes a StaticFile to <dest>/<dir>/<name>. Basing it on the gem
    # root put the runtime at /lib/assets/al_cookie/js/, while the script tag
    # emits /assets/al_cookie/js/ — so the file 404'd for anyone who switched
    # cookie consent on. It went unnoticed because the feature is off by default.
    entries = AlCookie.asset_entries

    refute_empty entries
    entries.each do |relative_dir, name|
      assert relative_dir.start_with?("assets/al_cookie"),
             "#{relative_dir}/#{name} would be published outside /assets/al_cookie"
      refute_includes relative_dir, "lib/"
    end
  end

  def test_the_script_tag_url_matches_a_published_file
    published = AlCookie.asset_entries.map { |dir, name| "/#{dir}/#{name}" }
    source = File.read(ROOT.join("lib/al_cookie.rb"))

    source.scan(%r{\{baseurl\}(/assets/al_cookie/[^"\s]+)}).flatten.each do |referenced|
      assert_includes published, referenced, "#{referenced} is referenced but never published"
    end
  end
end
