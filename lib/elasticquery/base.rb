require 'active_support/core_ext/class/attribute'
require 'elasticquery/query'
require 'elasticquery/queries/all'

# Base class for query builder. Superclass of your all builders
module Elasticquery
  class Base
    include Elasticquery::Queries::All

    class_attribute :filters
    attr_reader :params, :query

    self.filters = []

    # Define params processor for es query.
    #
    # @note Multiple filtered blocks can be defined.
    #
    # @yield [params] Block with defined filters for passed yield param processing
    #
    # @yieldparam [Hash] passed params to processing
    #
    # @example query builder for id
    #   class PostQuery < Elasticquery::Base
    #     filtered do |params|
    #       term "id" => params[:id]
    #     end
    #   end
    def self.filtered(&block)
      self.filters += [block]
    end

    # Is your object can process params to elasticqueriable.
    #
    # @return [Boolean]
    #
    # @example 
    #   class EmptyQuery < Elasticquery::Base
    #   end
    #   EmptyQuery.new.filterable? #=> false
    #
    # @example
    #   class PostQuery < Elasticquery::Base
    #     filtered { |params| true }
    #   end
    #   PostQuery.new.filterable? #=> true
    def filterable?
      filters.any?
    end

    # Create new query objects with built empty query.
    def initialize(params = {})
      @params = params
      @query = Query.new
    end

    # Build elasticquery query using defined filters.
    #
    # @example
    #   query.build # => { query: { match_all: {} }
    #
    # @return [Hash] elasticqueriable hash
    def build
      filters.each { |filter| instance_exec @params, &filter }
      query.to_hash
    end

    # Build elasticquery query using defined filters.
    #
    # @example
    #   query.build # => { query: { match_all: {} }
    #
    # @see Elasticquery::Base#build
    #
    # @return [Hash] elasticqueriable hash
    def self.build(params = {})
      new(params).build
    end
  end
end
