require 'pry-byebug'

class Presenter
  # the object being decorated.
  attr_reader :object
  # extra data to be used in user-defined method.
  attr_accessor :context

  def initialize(object, options = {})
    @object = object
    @context = options.fetch(:context, {})
  end

  class << self
    alias :decorate :new
  end

  def method_missing(method, *args, &block)
    return super unless delegatable?(method)

    object.send(method, *args, &block)
  end

  private

  def delegatable?(method)
    return if private_methods(false).include?(method)

    object.respond_to?(method)
  end
end
