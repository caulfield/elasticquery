require 'active_support/core_ext/class/attribute'
require 'elasticquery/query'
require 'elasticquery/queries/all'

module Elasticquery
  class Base

    include Queries::Term

    class_attribute :filters
    attr_reader :params, :query

    def self.filtered(&block)
      self.filters ||= []
      self.filters += [block]
    end

    def filterable?
      filters && !filters.empty?
    end

    def initialize(params = {})
      @params = params
      @query = Query.new
    end

    def build
      filters.each { |filter| instance_exec @params, &filter }
      query.to_hash
    end
  end
end
