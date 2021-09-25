require_relative 'interactor'

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
    if email == 'john@example.com' && password == 'password'
      { name: 'john', email: 'john@example.com' }
    else
      false
    end
  end
end

# success auth
result = AuthenticateUser.call(email: 'john@example.com', password: 'password')
p result.successful? #=> true
p result.user #=> {:name=>"john", :email=>"john@example.com"}

# failed auth
result = AuthenticateUser.call(email: 'john@example.com', password: 'invalid')
p result.success? #=> false
p result.user #=> nil
p result.errors #=> ["user authentication is failed"]
