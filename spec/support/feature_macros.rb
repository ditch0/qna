require 'rack_session_access/capybara'

module FeatureMacros
  def sign_in(user)
    page.set_rack_session('warden.user.user.key' => User.serialize_into_session(user))
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def mock_facebook_authorization
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '12345',
      info: {
        name: 'mockuser',
        email: 'user@somewhere.com'
      },
      credentials: {
        token:  'mock_token'
      }
    )
  end

  def mock_twitter_authorization
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '12345',
      info: {
        name: 'mockuser'
      },
      credentials: {
        token:  'mock_token',
        secret: 'mock_secret'
      }
    )
  end

  def visit_server(user: nil, wait: 2)
    url = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    url += "/dev/log_in/#{user.id}" if user.present?

    $stdout.puts "Visiting server on #{url}"
    Launchy.open(url)

    if wait.zero?
      $stdout.puts 'Press any key to continue.'
      $stdin.gets
      $stdout.puts 'Done.'
    else
      sleep wait
    end
  end
end
