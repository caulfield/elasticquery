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

  def test_push_query_should_combine_queries_by_bool_must_query
    @rule.expect :valid?, true
    @rule.expect :to_hash, {a: 1}
    @query.push_query @rule
    assert_equal({query: {filtered: {query: {bool: {must: [{a: 1}]}}}}}, @query.to_hash)

    @rule.expect :valid?, true
    @rule.expect :to_hash, {b: 1}
    @query.push_query @rule
    assert_equal({query: {filtered: {query: {bool: {must: [{a: 1}, {b: 1}]}}}}}, @query.to_hash)

    assert_equal 2, @query.queries.size
    assert @rule.verify
  end

  def test_push_query_should_not_merge_if_query_is_invalid
    @rule.expect :valid?, false
    @query.push_query @rule
    assert_equal(Elasticquery::Query::DEFAULT, @query.to_hash)

    assert @rule.verify
  end

  def test_push_filter_should_combine_filters_by_and_condition
    @rule.expect :valid?, true
    @rule.expect :to_hash, {a: 1}
    @query.push_filter @rule
    assert_equal({query: {filtered: {filter: {and: [{a: 1}]}}}}, @query.to_hash)

    @rule.expect :valid?, true
    @rule.expect :to_hash, {b: 1}
    @query.push_filter @rule
    assert_equal({query: {filtered: {filter: {and: [{a: 1}, {b: 1}]}}}}, @query.to_hash)

    assert_equal 2, @query.filters.size
    assert @rule.verify
  end

  def test_push_filter_should_not_merge_if_filter_is_invalid
    @rule.expect :valid?, false
    @query.push_filter @rule
    assert_equal(Elasticquery::Query::DEFAULT, @query.to_hash)

    assert @rule.verify
  end
  class Elasticquery::Query
    # query context
    def forty_two
      42
    end
  end

  def test_merge_when_filters_is_lambda_uses_es_query_context
    @rule.expect :valid?, true
    @rule.expect :to_hash, -> { {forty_two: forty_two} }
    @query.push_filter @rule
    assert_equal @query.to_hash, {query: {filtered: {filter: {and: [{forty_two: 42}]}}}}

    assert @rule.verify
  end
end
