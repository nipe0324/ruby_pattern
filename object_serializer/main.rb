require_relative 'serializers'

[
  true, # TrueClass
  nil, # NilClass
  100, # Integer
  :something, # Symbol
  { a: 1, 'b' => 2 }, # Hash
  (10..15), # Range
  (10...15), # Range exclude end
].each do |value|
  puts "value: #{value.inspect}"

  serialized = Serializers.serialize(value)
  puts "serialized: #{serialized.inspect}"

  deserialized = Serializers.deserialize(serialized)
  puts "deserialized: #{deserialized.inspect}"
  puts
end

# value: true
# serialized: true
# deserialized: true
#
# value: nil
# serialized: nil
# deserialized: nil
#
# value: 100
# serialized: 100
# deserialized: 100
#
# value: :something
# serialized: {"_object_serializer"=>"Serializers::SymbolSerializer", "value"=>"something"}
# deserialized: :something
#
# value: {:a=>1, "b"=>2}
# serialized: {"_object_serializer"=>"Serializers::HashSerializer", "a"=>1, "b"=>2, "_symbol_keys"=>["a"]}
# deserialized: {:a=>1, "b"=>2}
#
# value: 10..15
# serialized: {"_object_serializer"=>"Serializers::RangeSerializer", "begin"=>10, "end"=>15, "exclude_end"=>false}
# deserialized: 10..15
#
# value: 10...15
# serialized: {"_object_serializer"=>"Serializers::RangeSerializer", "begin"=>10, "end"=>15, "exclude_end"=>true}
# deserialized: 10...15
