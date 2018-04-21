ENV['DB'] = 'test'

require './spec/support/config/database_cleaner'
require './spec/support/config/sidekiq'
require './spec/support/config/strigil.rb'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.order = :random

  Kernel.srand config.seed
end

require './spec/support/factory_bot.rb'
