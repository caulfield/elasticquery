require_relative "base"

module Elasticquery
  module Filters
    class Term < Base
      OPTIONS = %i(_cache)

      def initialize(data = {})
        @options = data.slice *OPTIONS
        @condition = data.except *OPTIONS
      end

      def valid?
        @condition.keys.size == 1 && @condition.values[0].present?
      end

      def to_hash
        {term: @condition.merge(@options)}
      end
    end
  end
end
