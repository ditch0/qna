require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  if Nenv.open_screenshots?
    Capybara::Screenshot.after_save_screenshot do |path|
      Launchy.open path
    end

    Capybara::Screenshot.after_save_html do |path|
      Launchy.open path
    end
  end

  Capybara::Screenshot.prune_strategy = :keep_last_run
end
