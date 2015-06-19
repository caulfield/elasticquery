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

  def test_simple_setup
    params = {query: "Mark", required: "name"}
    actual = UserQuery.new(params).build

    expected_query = {multi_match: {fields: "_all", operator: "and", type: "best_fields", query: "Mark"}}
    expected_filters = [{exists: {field: "name"}}]
    assert_equal expected_query, actual[:query][:filtered][:query]
    assert_equal expected_filters, actual[:query][:filtered][:filter][:and]
  end

  def test_exists_not_use_missing
    params = {query: "Mark", missing: "deleted_at"}
    actual = UserQuery.new(params).build
    expected_filters = [{missing: {field: "deleted_at"}}]
    assert_equal expected_filters, actual[:query][:filtered][:filter][:and]
  end
end
