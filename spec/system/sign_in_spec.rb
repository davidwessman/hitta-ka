require "rails_helper"

RSpec.describe "Sign in", type: :system do
  chrome_opts = {
    'goog:chromeOptions' => {
      'args' => %w[no-sandbox headless disable-gpu --window-size=1920x1080]
    }
  }

  Capybara.register_driver(:custom_chrome_headless) do |app|
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 120
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      capabilities: [
        Selenium::WebDriver::Remote::Capabilities.chrome(chrome_opts)
      ],
      http_client: client
    )
  end

  before do
    driven_by(:custom_chrome_headless)
    user = create(:organisation_user).user
    sign_in_as(user)
  end

  it("failure") do
    visit(sign_in_path)
    expect(page).to have_content("Hello world")
  end

  it("success") do
    visit(sign_in_path)
    expect(page).to have_content("Logga in på ditt konto")
  end

  it("skipped", skip: true) do
    visit(sign_in_path)
    expect(page).to have_content("Skipped")
  end

  it("error") do
    visit(sign_in_path)
    invalid_code
  end
end
