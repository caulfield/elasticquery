require_relative "base"

module Elasticquery
  module Filters
    class Exists < Base

      def initialize(field = nil)
        @field = field
      end

      def valid?
        @field.present?
      end

      def to_hash
        {exists: {field: @field}}
      end

      def to_not_hash
        {missing: {field: @field}}
      end
    end
  end
end
