require "test_helper"
require "elasticquery/builder"

class TestAllBaseQueries < MiniTest::Test
  include Elasticquery::Builder

  attr_accessor :query

  def setup
    clear_query
  end

  def teardown
    clear_query
  end

  def test_have_term
    assert_respond_to self, :term
  end

  def test_have_search
    assert_respond_to self, :search
  end

  def test_defined_instances_return_sel
    assert_equal self, term
  end

  def test_push_hash_term_to_query
    term a: 1
    search b: 2
    term c: 3
    assert_equal 3, query.size
  end

  private

  def clear_query
    @query = []
  end
end
