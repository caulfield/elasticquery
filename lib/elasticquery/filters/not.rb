require_relative "base"

module Elasticquery
  module Filters
    class Not < Base

      # Create not filter by wrapping previous one.
      # 
      # Constructor proxies all arguments
      def initialize(*args)
        @args = args
      end

      def dup_with(*args)
        raise StandardError, "Cannot use Filters::Not twice"
      end

      # Hash presentation of previous filter with given arguments
      #
      # @return [Hash]
      def to_hash
        args = @args
        -> do
          filter = filters.last.dup_with *args
          if filter.valid?
            subquery = filter.to_hash
            q = subquery[:query][:filtered][:filter][:and][0]
            {query: {filtered: {filter: {and: [{not: {filter: q}}]}}}}
          else
            {}
          end
        end
      end
    end
  end
end
