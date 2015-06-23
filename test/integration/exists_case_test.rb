require "test_helper"
require "elasticquery"

class TestExistsCase < MiniTest::Test
  class UserQuery < Elasticquery::Base
    filtered do |params|
      queries do
        search params[:query]
      end
      filters do
        exists params[:required]
        with.not params[:missing]
      end
    end
  end

  class SimpleUserQuery < Elasticquery::Base
    filtered do |params|
      filters do
        without params[:missing]
        missing params[:another_missing]
      end
    end
  end

  def test_simple_setup
    params = {query: "Mark", required: "name"}
    actual = UserQuery.new(params).build

    expected_queries = [{multi_match: {fields: "_all", operator: "and", type: "best_fields", query: "Mark"}}]
    expected_filters = [{exists: {field: "name"}}]
    assert_equal expected_queries, actual[:query][:filtered][:query][:bool][:must]
    assert_equal expected_filters, actual[:query][:filtered][:filter][:and]
  end

  def test_exists_not_use_missing
    params = {query: "Mark", missing: "deleted_at"}
    actual = UserQuery.new(params).build
    expected_filters = [{missing: {field: "deleted_at"}}]
    assert_equal expected_filters, actual[:query][:filtered][:filter][:and]
  end

  def test_without_support
    params = {missing: "deleted_at"}
    actual = SimpleUserQuery.new(params).build
    expected_filters = [{missing: {field: "deleted_at"}}]
    assert_equal expected_filters, actual[:query][:filtered][:filter][:and]
  end

  def test_missing_support
    params = {another_missing: "deleted_at"}
    actual = SimpleUserQuery.new(params).build
    expected_filters = [{missing: {field: "deleted_at"}}]
    assert_equal expected_filters, actual[:query][:filtered][:filter][:and]
  end
end
