require "elasticquery/filters/term"
require "elasticquery/filters/not"
require "elasticquery/filters/terms"
require "elasticquery/filters/range"
require "elasticquery/filters/exists"

require "elasticquery/queries/multi_match"

require "active_support/concern"
require "active_support/core_ext/string/inflections"

module Elasticquery
  module Builder
    extend ActiveSupport::Concern

    def filters
      @namespace = "Filters"
      if block_given?
        yield
        @namespace = nil
      end
      self
    end

    def queries
      @namespace = "Queries"
      if block_given?
        yield
        @namespace = nil
      end
      self
    end

    def execute(method, *args)
      filter_class = "Elasticquery::#{@namespace}::#{method.camelize}".constantize
      instance = filter_class.new *args
      case @namespace
      when "Filters"
        query.push_filter instance
      when "Queries" 
        query.push_query instance
      else
        raise "Please specify block. Queries and Filters are supported"
      end
      self
    end
    private :execute

    def term(*args)
      execute "term", *args
    end

    def terms(*args)
      execute "terms", *args
    end

    def not(*args)
      execute "not", *args
    end

    def range(*args)
      execute "range", *args
    end

    def multi_match(*args)
      execute "multi_match", *args
    end

    def search(*args) 
      multi_match *args
    end

    def exists(*args)
      execute "exists", *args
    end

    def with(*args)
      exists *args
    end
  end
end
