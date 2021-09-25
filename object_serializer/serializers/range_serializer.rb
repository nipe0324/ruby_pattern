class Serializers
  class RangeSerializer < ObjectSerializer
    KEYS = %w[begin end exclude_end].freeze

    def serialize(range)
      args = [range.begin, range.end, range.exclude_end?].map { |value| Serializers.serialize(value) }
      super(KEYS.zip(args).to_h)
    end

    def deserialize(hash)
      args = hash.values_at(*KEYS).map { |value| Serializers.deserialize(value) }
      klass.new(*args)
    end

    private

    def klass
      ::Range
    end
  end
end
