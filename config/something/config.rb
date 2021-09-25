module Something
  class << self
    def configure
      yield config
    end

    private

    def config
      @_config ||= Config.new
    end
  end

  class Config
    attr_accessor :foo, :bar

    def initialize
      @foo = 10
      @bar = :something
    end

    # NOTE: validate args
    def bar=(value)
      if value.nil? || !value.is_a?(Symbol)
        raise ArgumentError, 'bar must be Symbol'
      end

      @bar = value
    end
  end
end
