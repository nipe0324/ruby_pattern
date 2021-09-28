require_relative "model/migration"
require_relative "model/configuration"

module Model
  class << self
    def migration(&block)
      Migration.new(configuration.gateways[:default])
    end

    def configure
      yield configuration
    end

    def configuration
      @_configuration ||= Configuration.new
    end
  end
end
