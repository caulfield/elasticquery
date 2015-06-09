require "deep_merge/rails_compat"

module Elasticquery
  class Query

    attr_reader :filters

    DEFAULT = {query: {filtered: {query: {match_all:{}}}}}

    # Create new query from hash.
    #
    # @param [Hash] query passed as hash. When it not passed use default es 'match_all' query
    #
    # @example
    #   Elasticsearch::Query.new.to_hash #=> {query: {filtered: {query: {match_all:{}}}}}
    def initialize(query = DEFAULT)
      @query = query
      @filters = []
    end

    # Convery query object ot hash
    #
    # @return [Hash] hash presentation of query
    def to_hash
      @query
    end

    # Merge filter to query. If current query is `matche_all`ed
    # then clear it and use new value. Populate #filters array
    # with given classes
    #
    # @param [Elasticquery::filter::Base] filter passed
    #
    # @see #match_all?
    def <<(filter)
      @query = {} if match_all?
      merge filter
      @filters << filter
    end

    # Ckeck current object to default elasticsearch param
    #
    # @return [Boolean] is passed query undefined
    def match_all?
      @query == DEFAULT
    end

    private

    def merge(filter)
      hash = filter.to_hash
      subquery = hash.respond_to?(:call) ? instance_exec(&hash) : hash
      @query.deeper_merge! subquery
    end

    def _filters
      @query[:query] &&
        @query[:query][:filtered] &&
        @query[:query][:filtered][:filter] &&
        @query[:query][:filtered][:filter][:and]
    end
  end
end
