# frozen_string_literal: true

ENV["RACK_ENV"] = "test"

require File.expand_path("../application.rb", __dir__)
require File.expand_path("factory_bot_helper.rb", __dir__)

require "dotenv/load"
require "database_cleaner"
require "factory_bot"
require "faker"
require "rack/test"
require "rspec"
require "vcr"
require "webmock/rspec"

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path("fixtures/vcr_cassettes", __dir__)
  config.hook_into(:webmock)
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
