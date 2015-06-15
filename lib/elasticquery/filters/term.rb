require_relative "base"

module Elasticquery
  module Filters
    class Term < Base
      OPTIONS = %i(_cache)

      # Create term filter for elasticsearch builder
      #
      # @param [Hash] condition passed to define
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-filtered-query.html#_filtering_without_a_query
      def initialize(data={})
        @options = data.extract! *OPTIONS
        @condition = data
      end

      # Is passed condition valid. Passed condition must have
      # one key and present value
      # 
      # @return [Boolean] is condition have at least one key
      #
      # @example
      #   rule = Elasticquery::Rules::Term.new
      #   rule.valid? #=> false
      def valid?
        @condition.keys.size == 1 && @condition.values[0].present?
      end

      # Hash presentation of query.
      #
      # @return [Hash] presentation of filter.
      #
      # @example
      #   valid = Elasticquery::Filters::Term.new {name: "John"}
      #   valid.to_hash #=> {query: {filtered: {filter: {and: [{term: {name: 'John'}}]}}}
      def to_hash
        if valid?
          {query: {filtered: {filter: {and: [{term: @condition.merge(@options)}]}}}}
        else
          {}
        end
      end
    end
  end
end
