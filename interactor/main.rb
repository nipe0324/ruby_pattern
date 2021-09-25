require_relative 'interactor'

User = Struct.new(:name, :email)

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

  private

  def valid_params(email, password)
    !email.nil? && !password.nil?
  end

  def authenticate(email, password)
    user_store.find { |user| email == user.email && password == 'password' } || false
  end

  def user_store
    @user_store ||= [
      User.new('john', 'john@example.com')
    ]
  end
end

# success auth
result = AuthenticateUser.call(email: 'john@example.com', password: 'password')
p result.successful? #=> true
p result.user #=> #<struct User name="john", email="john@example.com">
p result.errors #=> []

# failed auth
result = AuthenticateUser.call(email: 'john@example.com', password: 'invalid')
p result.success? #=> false
p result.user #=> nil
p result.errors #=> ["user authentication is failed"]
