require "test_helper"
require "elasticquery"

class TestChainableCalls < MiniTest::Test

  def setup
    @query = Elasticquery::Base.new
  end

  def test_sign_call_return_itself
    assert_kind_of Elasticquery::Base, @query.filters.term(a: 1)
  end

  def test_apply_query
    query = @query.filters.term(a: 1).term(b: 3)
    assert_equal query.build, query: {filtered: {filter: {and: [{term: {a: 1}}, {term: {b: 3}}]}}}
  end

  def test_with_not_filter
    query = @query.queries.search("hi").filters.term.not(a: 1, _cache: true)
    assert_equal query.build, {query: {filtered: {query: {multi_match: {fields: "_all", operator: "and", type: "best_fields", query: "hi"}}, filter: {and: [{not: {filter: {term: {a: 1, _cache: true}}}}]}}}}
  end

  def test_apply_kinds_of_query
    query = @query.filters.term(a: 1).queries.search("hello", operator: "or").build
    terms = query[:query][:filtered][:filter][:and]
    search = query[:query][:filtered][:query][:multi_match]
    assert_equal terms, [{term: {a: 1}}]
    assert_equal search, {fields: "_all", operator: "or", type: "best_fields", query: "hello"}
  end
end
