require_relative 'base'

module Elasticquery
  module Filters
    class Range < Base

      def initialize(field, gte: nil, lte: nil)
        @field, @gte, @lte = field, gte, lte
      end

      def valid?
        @gte || @lte
      end

      def to_hash
        valid? ? {query: {filtered: {filter: {and: {range: range}}}}} : {}
      end

      private
      
      def range
        {@field => {}}.tap do |r|
          r[@field][:lte] = @lte unless @lte.nil?
          r[@field][:gte] = @gte unless @gte.nil?
        end
      end
    end
  end
end
