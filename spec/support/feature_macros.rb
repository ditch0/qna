module FeatureMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
