require_relative "base"

module Elasticquery
  module Filters
    class Range < Base
      OPTIONS = %i(_cache execution)

      def initialize(field=nil, gte: nil, lte: nil, **options)
        @options = options.extract! *OPTIONS
        @field, @gte, @lte = field, gte, lte
      end

      def valid?
        @gte.present? || @lte.present?
      end

      def to_hash
        if valid?
          {query: {filtered: {filter: {and: [{range: range_with_options}]}}}}
        else
          {}
        end
      end

      private
      
      def range_with_options
        {@field => @options}.tap do |r|
          r[@field][:lte] = @lte unless @lte.nil?
          r[@field][:gte] = @gte unless @gte.nil?
        end
      end
    end
  end
end
