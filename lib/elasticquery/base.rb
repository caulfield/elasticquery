require "active_support/core_ext/class/attribute"
require "elasticquery/query"
require "elasticquery/builder"

# Base class for query builder. Superclass of your all builders
module Elasticquery
  class Base
    include Elasticquery::Builder

    class_attribute :rules
    attr_reader :params, :query

    self.rules = []

    def self.filtered(&block)
      self.rules += [block]
    end

    def filterable?
      rules.any?
    end

    def initialize(params = {})
      @params = params
      @query = Query.new
    end

    def build
      @namespace = nil
      rules.each { |rule| instance_exec @params, &rule }
      query.to_hash
    end

    def self.build(params = {})
      new(params).build
    end
  end
end
