require 'elasticquery/rules/term'

module Elasticquery
  module Queries
    module Term
      def term(options)
        rule = Rules::Term.new options
        query << rule if rule.valid?
      end
    end
  end
end
