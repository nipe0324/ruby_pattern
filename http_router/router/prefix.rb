# frozen_string_literal: true

class Router
  class Prefix
    def initialize(prefix)
      @prefix = prefix
    end

    def join(path)
      self.class.new(
        _join(path)
      )
    end

    def to_s
      @prefix
    end

    private

    DEFAULT_SEPARATOR = "/"
    DOUBLE_DEFAULT_SEPARATOR_REGEXP = /\/{2,}/.freeze

    def _join(path)
      return @prefix if path == DEFAULT_SEPARATOR

      [@prefix, DEFAULT_SEPARATOR, path]
        .join.gsub(DOUBLE_DEFAULT_SEPARATOR_REGEXP, DEFAULT_SEPARATOR)
    end
  end
end
