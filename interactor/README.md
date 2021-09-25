# Interactor

Implemente business logic and return success or not and some objects easily.

## Inspired by

* [Hanami::Utils](https://github.com/hanami/utils)
* [Interactor](https://github.com/collectiveidea/interactor)

## Example

```rb
# Implement business logic with `Interactor`
class AuthenticateUser
  include Interactor

  def call(email:, password:)
    error!('invalid parameters') unless valid_params(email, password)

    user = authenticate(email, password)
    if user
      result.user = user
    else
      error!('user authentication is failed')
    end
  end

  # ...
end

# Caller handles usefull result.
result = AuthenticateUser.call(email: 'john@example.com', password: 'password')
result.successful? #=> true
result.user        #=> #<struct User name="john", email="john@example.com">
result.errors      #=> []
```
