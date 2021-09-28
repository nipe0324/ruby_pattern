# bundle exec ruby main.rb

require_relative "lib/model"
require_relative "lib/model/migrator"

# TODO: https://github.com/hanami/model/blob/f648d29105291431dc75d2ef4446518dcd20d742/spec/support/database/strategies/sqlite.rb
# Need gateway
Model.configure do |config|
  config.url = "sqlite://test.sqlite3"
end

# Create database
Model::Migrator.create

# Migrate
Model::Migrator.migrate

# Drop database
# Model::Migrator.drop
