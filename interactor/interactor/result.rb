require "ostruct"

module Interactor
  class Result < ::OpenStruct
    def initialize
      super
      @errors = []
      @success = true
    end

    def successful?
      @success && errors.empty?
    end
    alias_method :success?, :successful?

    def failure?
      !successful?
    end

    def fail!
      @success = false
    end

    def errors
      @errors.dup
    end

    def add_error(*errors)
      @errors << errors
      @errors.flatten!
      nil
    end

    def error
      errors.first
    end
  end
end
