RSpec.configure do |config|
  config.before(:suite) do
    config.include FactoryGirl::Syntax::Methods

    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
