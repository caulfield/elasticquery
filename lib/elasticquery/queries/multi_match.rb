require_relative "base"

module Elasticquery
  module Queries
    class MultiMatch < Base
      OPERATORS = %w(and or)
      TYPES = %w(best_fields most_fields cross_fields phrase pharse_prefix)

      def initialize(query, fields: "_all", operator: "and", type: "best_fields")
        @fields = fields
        @operator = operator
        @type = type
        @query = query
      end

      def valid?
        OPERATORS.include?(@operator) &&
          TYPES.include?(@type) &&
          @query.present? &&
          ( Array === @fields || @fields == "_all" )
      end
      
      def to_hash
        {multi_match: subquery}
      end

      private

      def subquery
        {fields: @fields, operator: @operator, type: @type, query: @query}
      end
    end
  end
end
