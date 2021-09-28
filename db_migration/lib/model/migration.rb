module Model
  class Migration
    attr_reader :gateway
    attr_reader :migration

    def initalize(gateway, &block)
      @gateway = gateway
      @migration = gateway.migration(&block)
      freeze
    end

    def run(direction = :up)
      migration.apply(gateway.connection, direction)
    end
  end
end
