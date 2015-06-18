module Elasticquery
  class Query

    attr_reader :filters, :queries

    DEFAULT = {query: {filtered: {query: {match_all:{}}}}}

    def initialize(query = DEFAULT)
      @query = query
      @filters, @queries = [], []
    end

    def to_hash
      @query
    end

    def push_filter(filter)
      @filters << filter
      merge_filter filter
    end

    def push_query(query)
      @queries << query
      merge_query query
    end

    private

    def merge_filter(filter)
      return unless filter_valid?(filter)

      hash = filter.to_hash
      subquery = hash.respond_to?(:call) ? instance_exec(&hash) : hash
      @query = {query: {filtered: {}}} if @query == DEFAULT

      @query[:query][:filtered][:filter] ||= {and: []}
      @query[:query][:filtered][:filter][:and] << subquery
    end

    def filter_valid?(filter)
      validation = filter.valid?
      validation.respond_to?(:call) ? instance_exec(&validation) : validation
    end

    def merge_query(query)
      return unless query.valid?
      @query = {query: {filtered: {}}} if @query == DEFAULT

      @query[:query][:filtered][:query] ||= {}
      @query[:query][:filtered][:query].merge! query.to_hash
    end
  end
end
