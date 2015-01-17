require_relative 'base'

module Elasticquery
  module Rules
    class Term < Base

      def initialize(condition = {})
        @condition = condition
      end

      def valid?
        @condition.keys.size == 1
      end

      def to_hash
        {query: {filtered: {filter: {:and => @condition}}}}
      end
    end
  end
end
