require 'test_helper'
require 'elasticquery/query'

class TestQuery < MiniTest::Test

  def setup
    @query = Elasticquery::Query.new
    @rule = MiniTest::Mock.new
  end

  def teardown
    assert @rule.verify
  end

  def test_default_query
    assert_equal({query: {filtered: {query: {match_all:{}}}}}, @query.to_hash)
  end

  def test_default_query_should_be_matched_all
    assert @query.match_all?
    @rule.expect :to_hash, {a: 1}
    @query << @rule
    refute @query.match_all?
  end

  def test_pushing_of_hash_to_new_query
    @rule.expect :to_hash, {a: 2, b: 1}
    @query << @rule
    assert_equal({a:2, b: 1}, @query.to_hash)
  end

  def test_pushing_of_subquery_to_existing_one
    @rule.expect :to_hash, {a: 2, b: 1}
    @query << @rule
    @rule.expect :to_hash, {a: 1}
    @query << @rule
    assert_equal({a:1, b: 1}, @query.to_hash)
  end
end
