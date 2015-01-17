require 'test_helper'
require 'elasticquery/queries/term'

class TestTermQuery < MiniTest::Test
  include Elasticquery::Queries::Term

  def test_should_have_term_method
    assert_respond_to self, :term
  end
end
