require_relative 'something/config'

# set by configure
Something.configure do |config|
  p config.foo #=> 10
  p config.bar #=> :something

  config.foo = 20
  config.bar = :hoge

  p config.foo #=> 20
  p config.bar #=> :hoge
end

# validate setter
Something.configure do |config|
  config.bar = 'invalid' # `bar=': bar must be Symbol (ArgumentError)
end
