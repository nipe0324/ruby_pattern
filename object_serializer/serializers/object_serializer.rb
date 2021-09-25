require 'singleton'
require 'forwardable'

class Serializers
  class ObjectSerializer
    include Singleton

    class << self
      extend Forwardable
      delegate [:serialize?, :serialize, :deserialize] =>  :instance
      # delegate :serialize?, :serialize, :deserialize, to: :instance
    end

    def serialize?(argument)
      argument.is_a?(klass)
    end

    def serialize(hash)
      { OBJECT_SERIALIZER_KEY => self.class.name }.merge!(hash)
    end

    def deserialize(json)
      raise NotImplementedError
    end

    private

    # The class of the object that will be serialized.
    def klass
      raise NotImplementedError
    end
  end
end
