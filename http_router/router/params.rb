# frozen_string_literal: true

class Router
  class Params
    def self.deep_symbolize(params)
      params.each_with_object({}) do |(key, value), result|
        result[key.to_sym] =
          case value
          when Hash
            deep_symbolize(value)
          when Array
            value.map do |item|
              item.is_a?(Hash) ? deep_symbolize(item) : item
            end
          else
            value
          end
      end
    end
  end
end
