require 'active_support/core_ext/hash/deep_merge'

module Elasticquery
  class Query

    DEFAULT = {query: {filtered: {query: {match_all:{}}}}}

    def initialize(query = DEFAULT)
      @query = query
    end

    def to_hash
      @query
    end

    def <<(subquery)
      @query = {} if match_all?
      @query.deep_merge! subquery.to_hash
    end

    def match_all?
      @query == DEFAULT
    end
  end
end
