require 'test_helper'
require 'elasticsearch/model'
require 'elasticquery/es'

class Searchable
  include Elasticsearch::Model
end

class NotSearchable
end

class TestEs < MiniTest::Test
  def setup
    Searchable.extend Elasticquery::Es
    @model = Searchable
  end

  def test_raise_error_for_not_searchable_class
    assert_raises Elasticquery::EsNotSupported do
      NotSearchable.extend Elasticquery::Es
    end
  end
end
