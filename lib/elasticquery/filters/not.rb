require_relative "base"

module Elasticquery
  module Filters
    class Not < Base

      def initialize(*args)
        @args = Marshal.load(Marshal.dump(args))
      end

      def dup_with(*args)
        raise StandardError, "Cannot use Filters::Not twice"
      end

      def valid?
        args = @args
        -> { filters[-2].dup_with(*args).valid? }
      end

      def to_hash
        args = @args
        -> do
          filter = filters[-2].dup_with *args
          # longer form
          {not: {filter: filter.to_hash}}
        end
      end
    end
  end
end
