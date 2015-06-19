require 'active_support/core_ext/object/blank'

module Elasticquery
  module Filters
    class Base

      def valid?
        true
      end

      def invalid?
        !valid?
      end

      def to_not_hash
        {not: {filter: to_hash}}
      end

      def dup_with(*args)
        self.class.new *args
      end
    end
  end
end
