require 'set'
require 'bigdecimal'
require './serializers/object_serializer'
require './serializers/symbol_serializer'
require './serializers/range_serializer'
require './serializers/hash_serializer'

class Serializers
  # Serialization keys
  OBJECT_SERIALIZER_KEY = "_object_serializer"
  SYMBOL_KEYS_KEY = "_symbol_keys"
  # Skip serialization and deseriazation
  PERMITTED_TYPES = [ NilClass, String, Integer, Float, BigDecimal, TrueClass, FalseClass ]

  # Error Class
  class SerializationError < ArgumentError; end
  class DeserializationError < ArgumentError; end

  # Store additional serializers
  @@_additional_serializers = ::Set.new

  class << self
    # serialize object
    def serialize(argument)
      case argument
      when *PERMITTED_TYPES
        argument
      when Array
        argument.map { |arg| serialize(arg) }
      else
        serializer = serializers.detect { |s| s.serialize?(argument) }
        raise SerializationError.new("Unsupported argument type: #{argument.class.name}") unless serializer

        serializer.serialize(argument)
      end
    end

    def deserialize(argument)
      case argument
      when *PERMITTED_TYPES
        argument
      when Array
        argument.map { |arg| deserialize(arg) }
      else
        serializer_name = argument[OBJECT_SERIALIZER_KEY]
        raise DeserializationError, "Serializer name is not present in the argument: #{argument.inspect}" unless serializer_name

        serializer = ::Object.const_get(serializer_name)
        raise DeserializationError, "Serializer #{serializer_name} is not known" unless serializer

        serializer.deserialize(argument)
      end
    end

    def serializers
      @@_additional_serializers
    end

    def add_serializers(*new_serializers)
      @@_additional_serializers += new_serializers
    end
  end

  add_serializers SymbolSerializer,
    RangeSerializer,
    HashSerializer
end
