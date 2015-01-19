require_relative 'base'

module Elasticquery
  module Filters
    class Not < Base

      def initialize(condition = {})
        @condition = condition
      end

      def dup_with(*args)
        raise StandardError, 'Cannot use Filters::Not twice'
      end

      def to_hash
        condition = @condition
        -> do
          filter = filters.last.dup_with condition
          if filter.valid?
            subquery = filter.to_hash
            q = subquery[:query][:filtered][:filter][:and]
            {query: {filtered: {filter: {and: {not: {filter: q}}}}}}
          else
            {}
          end
        end
      end
    end
  end
end
