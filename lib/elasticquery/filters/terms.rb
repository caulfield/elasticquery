require "active_support/core_ext/array/wrap"
require_relative "base"

module Elasticquery
  module Filters
    class Terms < Base
      OPTIONS = %i(_cache execution)

      def initialize(data = {})
        @options = data.slice *OPTIONS
        @conditions = data.except(*OPTIONS).delete_if{ |_, value| value.blank? }
      end

      def valid?
        @conditions.keys.any?
      end

      def to_hash
        {terms: @conditions.merge(@options)}
      end
    end
  end
end
