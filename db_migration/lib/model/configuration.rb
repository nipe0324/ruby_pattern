require 'pathname'
require 'logger'

module Model
  class Configuration
    attr_accessor :url
    attr_accessor :migrations
    attr_accessor :migrations_logger

    def initialize
      @url = "" # Required
      @migrations = Pathname.pwd.join("db", "migrations")
      # @schema = configurator._schema
      # @gateway_config = configurator._gateway
      @migrations_logger = Logger.new(STDOUT)
    end
  end
end
