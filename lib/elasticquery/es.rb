module Elasticquery
  EsNotSupported = Class.new(StandardError)

  class BaseChain < Elasticquery::Base
    def initialize(klass)
      @klass = klass
      super
    end

    delegate :each, :empty?, :size, :slice, :[], :to_ary, to: :results

    def records
      results.records
    end

    def results
      @klass.__elasticsearch__.search(build)
    end
  end

  module Es
    def self.extended(base)
      unless base.ancestors.include? Elasticsearch::Model
        raise EsNotSupported.new("Can't extend. It's not Elasticsearch::Model")
      end
    end

    def es
      BaseChain.new(self)
    end
  end
end
