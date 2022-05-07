RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Cleaning up any images which may have been created as part of the test suite.
  config.after(:all) do
    # Let's MAKE SURE this never runs in prod in case we ever run rspec there.
    if Rails.env.test? || Rails.env.development?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end
end