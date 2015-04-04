RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:all) do
    DatabaseCleaner.clean_with :truncation
  end

  config.after(:all) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each, js: false) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion, { pre_count: true }
  end

  config.before(:each) do |example|
    DatabaseCleaner.start unless example.metadata[:db]
  end

  config.after(:each) do |example|
    DatabaseCleaner.clean unless example.metadata[:db]
  end
end
