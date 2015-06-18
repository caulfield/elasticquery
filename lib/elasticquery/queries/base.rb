require 'active_support/core_ext/object/blank'

module Elasticquery
  module Queries
    class Base

      def valid?
        true
      end

      def invalid?
        !valid?
      end
    end
  end
end
