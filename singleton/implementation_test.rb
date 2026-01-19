require "minitest/autorun"
require_relative "implementation"
require 'tempfile'
require 'pry'

class ConfigTest < Minitest::Test
  def setup
    @file = Tempfile.new('config.json')
    @file.write <<-JSON
    {
      "log_level": "info",
      "payments_provider": "stripe",
      "max_retries": 3,
      "features": {
        "new_checkout": false,
        "dark_mode": false
      }
    }
    JSON
    @config = Config.instance
    @file.rewind
  end


  def test_singleton_instance
    another_instance = Config.instance
    assert_equal @config.object_id, another_instance.object_id
  end

  def test_settings_access
    assert_equal "info", @config.get("log_level")
    assert_equal "stripe", @config.get("payments_provider")
    assert_equal 3, @config.get("max_retries")
    assert_equal false, @config.get("features.new_checkout")
    assert_equal false, @config.get("features.dark_mode")
  end

  def test_override_setting
    @config.set("log_level", "debug")
    @config.set("features.dark_mode", true)
    assert_equal "debug", @config.get("log_level")
    assert_equal true, @config.get("features.dark_mode")

    @config.reload!(path: @file.path)
  end

end