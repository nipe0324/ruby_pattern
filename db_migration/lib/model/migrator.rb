
require "sequel"
require "sequel/extensions/migration"
require "pry-byebug"
require_relative "migrator/connection"
require_relative "migrator/adapter"

module Model
  class MigrationError < StandardError; end

  class Migrator
    # Create database
    def self.create
      new.create
    end

    # Drop database
    def self.drop
      new.drop
    end

    # Migrate database schema
    def self.migrate(version: nil)
      new.migrate(version: version)
    end

    # Rollback database schema
    def self.rollback(steps: 1)
      new.rollback(steps: steps)
    end

    def self.configuration
      Model.configuration
    end

    def initialize
      @configuration = self.class.configuration
      @adapter       = Adapter.for(configuration)
    end

    def create
      adapter.create
    end

    def drop
      adapter.drop
    end

    def migrate(version: nil)
      adapter.migrate(migrations, version) if migrations?
    end

    def rollback(steps: 1)
      adapter.rollback(migrations, steps.abs) if migrations?
    end

    private

    attr_reader :configuration
    attr_reader :connection
    attr_reader :adapter

    def migrations
      configuration.migrations
    end

    def migrations?
      Dir["#{migrations}/*.rb"].any?
    end
  end
end
