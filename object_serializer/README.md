# Object Serializer

Serialize and deserialize ruby object.

## Inspired by

* [ActiveJob::Seralizers](https://github.com/rails/rails/tree/main/activejob)

## Example

```rb
# Serialize and deserialize `Symbol` class
serialized = Serializers.serialize(:something)
#=> {"_object_serializer"=>"Serializers::SymbolSerializer", "value"=>"something"}
Serializers.deserialize(serialized)
#=> :something

# Serialize and deserialize `Range` class
serialized = Serializers.serialize((10..15))
#=> {"_object_serializer"=>"Serializers::RangeSerializer", "begin"=>10, "end"=>15, "exclude_end"=>false}
Serializers.deserialize(serialized)
#=> (10..15)
```
