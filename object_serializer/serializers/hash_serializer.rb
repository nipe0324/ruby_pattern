class Serializers
  class HashSerializer < ObjectSerializer
    KEYS = %w[begin end exclude_end].freeze

    def serialize(hash)
      result = hash.each_with_object({}) do |(key, value), hash|
        hash[key.to_s] = Serializers.serialize(value)
      end
      result[SYMBOL_KEYS_KEY] = hash.each_key.grep(Symbol).map!(&:to_s)

      super(result)
    end

    def deserialize(serialized_hash)
      result = serialized_hash.each_with_object({}) do |(key, value), hash|
        hash[key.to_s] = Serializers.deserialize(value)
      end
      result.delete(OBJECT_SERIALIZER_KEY)
      symbol_keys = result.delete(SYMBOL_KEYS_KEY)
      result = transform_symbol_keys(result, symbol_keys)
      result
    end

    private

    def klass
      ::Hash
    end

    def transform_symbol_keys(hash, symbol_keys)
      hash.to_h.transform_keys do |key|
        if symbol_keys.include?(key)
          key.to_sym
        else
          key
        end
      end
    end
  end
end
