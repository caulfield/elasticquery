module Elasticquery
  module Filters
    class Base

      def valid?
        true
      end

      def invalid?
        !valid?
      end

      def dup_with(*args)
        self.class.new *args
      end
    end
  end
end
