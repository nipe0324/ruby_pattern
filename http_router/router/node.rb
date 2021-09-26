require "mustermann/rails"

class Router
  # trie node
  class Node
    attr_reader :to

    def initialize
      @variable = nil
      @fixed = nil
      @to = nil
    end

    def put(segment, constraints)
      if variable?(segment)
        @variable ||= {}
        @variable[segment_for(segment, constraints)] ||= self.class.new
      else
        @fixed ||= {}
        @fixed[segment] ||= self.class.new
      end
    end

    def get(segment)
      return unless @variable || @fixed

      found = nil
      captured = nil

      found = @fixed&.fetch(segment, nil)
      return [found, nil] if found

      @variable&.each do |matcher, node|
        break if found

        captured = matcher.match(segment)
        found = node if captured
      end

      [found, captured&.named_captures]
    end

    def leaf?
      @to
    end

    def leaf!(to)
      @to = to
    end

    private

    def variable?(segment)
      /:/.match?(segment)
    end

    def fixed?(matcher)
      matcher.names.empty?
    end

    def segment_for(segment, **constraints)
      ::Mustermann.new(segment, type: :rails, capture: constraints)
    end
  end
end
