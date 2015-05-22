require_relative 'base'

module Elasticquery
  module Filters
    class Term < Base
      OPTIONS = %i(_cache)

      # Create filtered -> filter filter for elasticsearch
      # builder
      #
      # @param [Hash] condition passed to define
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-filtered-query.html#_filtering_without_a_query
      def initialize(condition={})
        @condition = condition
        extract_options!
      end

      # Is passed condition valid. Passed condition must have
      # one key
      # 
      # @return [Boolean] is condition have at least one key
      #
      # @example
      #   rule = Elasticquery::Rules::Term.new
      #   rule.valid? #=> false
      def valid?
        @condition.keys.size == 1
      end

      # Hash presentation of query.
      #
      # @return [Hash] presentation of filter.
      #
      # @example
      #   r = Elasticquery::filters::Term.new { name: "John" }
      #   r.to_hash #=> {query: {filtered: {filter: {and: {name: 'John'}}}}}
      def to_hash
        valid? ? {query: {filtered: {filter: {and: [{term: @condition.merge(@options)}]}}}} : {}
      end

      def extract_options!
        @options = @condition.extract! *OPTIONS
      end
    end
  end
end
