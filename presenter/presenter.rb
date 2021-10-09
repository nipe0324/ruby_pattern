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
end
