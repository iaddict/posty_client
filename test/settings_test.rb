require 'test_helper'

class SettingsTest < Minitest::Test
  def test_env
    assert_equal 'test', PostyClient.env
  end

  def test_settings_file_exists
    assert File.exist?(PostyClient::settings_file)
  end

  def test_default_settings
    assert_kind_of Hash, PostyClient::Settings.current_settings
    refute_nil PostyClient::Settings.access_token
  end

  def test_servers
    assert PostyClient::Settings.servers.count > 1
    assert_includes PostyClient::Settings.servers, 'server1'
    assert_includes PostyClient::Settings.servers, 'server2'
  end

  def test_threaded_server_access
    assert_nil PostyClient::Settings.current_server
    default_api_url = PostyClient::Settings.api_url

    threads = PostyClient::Settings.servers.map do |server|
      Thread.start do
        PostyClient::Settings.current_server = server
        assert_equal server, PostyClient::Settings.current_server
        assert_kind_of Hash, PostyClient::Settings.current_settings
        refute_equal default_api_url, PostyClient::Settings.api_url
        assert_match(/#{server}/, PostyClient::Settings.api_url)
      end
    end
    assert_nil PostyClient::Settings.current_server
    assert_equal default_api_url, PostyClient::Settings.api_url

    assert_equal 2, threads.count
    threads.map(&:join)

    assert_equal [false], threads.map(&:status).uniq # all threads terminated normally
  end
end
