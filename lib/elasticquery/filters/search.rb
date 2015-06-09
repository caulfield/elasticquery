require_relative "base"

module Elasticquery
  module Filters
    class Search < Base
      OPERATORS = %w(and or)
      TYPES = %w(best_fields most_fields cross_fields phrase pharse_prefix)

      # Create new search subquery
      #
      # @params [String] query keyword
      # @params [Array<String>] fields to search with. Default to "_all"
      # @params [String] operator search option
      # @params [String] type search option
      def initialize(query, fields: "_all", operator: "and", type: "best_fields")
        @fields = fields
        @operator = operator
        @type = type
        @query = query
      end

      # Is current query valid to exec
      #
      # @return [Boolean]
      #
      # @example
      #   filter = Elasticquery::Filters::Search.new 'hello'
      #   filter.valid? #=> true
      def valid?
        OPERATORS.include?(@operator) &&
          TYPES.include?(@type) &&
          ( Array === @fields || @fields == "_all" )
      end
      
      # Hash presentation of query.
      #
      # @return [Hash] presentation of filter.
      #
      # @example
      #   r = Elasticquery::Filters::Search.new { fields: ['name', 'country'], query: 'belarus' }
      #   r.to_hash #=> {query: {filtered: {query: {multi_match: {fields: ['name', 'country'], query: 'belarus'}}}}}
      def to_hash
        valid? ? {query: {filtered: {query: {multi_match: subquery}}}} : {}
      end

      private

      def subquery
        {fields: @fields, operator: @operator, type: @type, query: @query}
      end
    end
  end
end
