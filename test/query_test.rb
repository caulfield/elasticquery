require "test_helper"
require "elasticquery/query"

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

  def test_push_filters_to_variable
    @rule.expect :to_hash, {a: 2, b: 1}
    @query << @rule
    @rule.expect :to_hash, {a: 1}
    @query << @rule
    assert_equal 2, @query.filters.size
  end

  def test_should_group_filters_in_array
    @rule.expect :to_hash, query: {filtered: {filter: {and: [{term: {a: 1, _cache: true}}]}}}
    @query << @rule
    @rule.expect :to_hash, query: {filtered: {filter: {and: [{term: {c: 3}}]}}}
    @query << @rule
    @rule.expect :to_hash, query: {filtered: {filter: {and: [{range: {x: 3}}]}}}
    @query << @rule
    expected = {query: {filtered: {filter: {and: [{term: {a: 1, _cache: true}}, {term: {c: 3}}, {range: {x: 3}}]}}}}
    assert_equal(expected, @query.to_hash)
  end

  def test_should_group_multiple_terms_conditions
    @rule.expect :to_hash, query: {filtered: {filter: {and: [{terms: {a: %w(a b c)}}]}}}
    @query << @rule
    @rule.expect :to_hash, query: {filtered: {filter: {and: [{terms: {c: %w(x y z), execution: "bool"}}]}}}
    @query << @rule
    expected = {query: {filtered: {filter: {and: [{terms: {a: %w(a b c)}}, {terms: {c: %w(x y z), execution: "bool"}}]}}}}
    assert_equal(expected, @query.to_hash)
  end

  class Elasticquery::Query
    # query context
    def forty_two
      42
    end
  end
  def test_merge_when_filters_is_lambda_uses_query_context
    @rule.expect :to_hash, -> { {forty_two: forty_two} }
    @query << @rule
    assert_equal @query.to_hash, {forty_two: 42}
  end
end
