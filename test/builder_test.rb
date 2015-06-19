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

  def test_have_terms
    assert_respond_to self, :terms
  end

  def test_have_search
    assert_respond_to self, :search
  end

  def test_have_multi_match
    assert_respond_to self, :multi_match
  end

  def test_have_range
    assert_respond_to self, :range
  end

  def test_have_range
    assert_respond_to self, :exists
  end

  def test_have_range
    assert_respond_to self, :with
  end

  def test_defined_instances_return_self
    @query.expect :push_filter, true, [Elasticquery::Filters::Term]

    assert_equal self, filters { term(a: 1) }
    assert @query.verify
  end

  private

  def clear_query
    @query = MiniTest::Mock.new
  end
end
