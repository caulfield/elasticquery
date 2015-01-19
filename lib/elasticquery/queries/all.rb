require 'elasticquery/filters/term'
require 'elasticquery/filters/search'
require 'elasticquery/filters/not'
require 'elasticquery/filters/range'

require 'active_support/concern'
require 'active_support/core_ext/string/inflections'

module Elasticquery
  module Queries
    module All
      extend ActiveSupport::Concern

      filters = [
        Filters::Term,
        Filters::Search,
        Filters::Not,
        Filters::Range
      ]

      included do
        filters.each do |filter_class|
          filter_name = filter_class.to_s.split("::").last.underscore

          define_method filter_name do |*args|
            filter = filter_class.new *args
            query << filter
            self
          end
        end
      end
    end
  end
end
