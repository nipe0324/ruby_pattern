require_relative 'interactor/result'

module Interactor
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def call(*args)
      new._run(*args)
    end
  end

  def initialize
    @__result = ::Interactor::Result.new
  end

  def call(*args)
    fail NotImplementedError
  end

  def _run(*args)
    catch :fail do
      call(*args)
    end

    @__result
  end

  private

  def result
    @__result
  end

  def error(message)
    @__result.add_error(message)
    false
  end

  def error!(message)
    error(message)
    fail!
  end

  def fail!
    @__result.fail!
    throw :fail
  end
end
