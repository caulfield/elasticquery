require "test_helper"
require "elasticquery"

class TestRangeCase < MiniTest::Test
  class HumanQuery < Elasticquery::Base
    filtered do |params|
      filters do
        range :year, lte: params[:max_year], gte: params[:min_year], execution: "fielddata"
        range :revenue, lte: params[:max_revenue], gte: params[:min_revenue]
      end
    end
  end

  def test_simple_range
    params = { min_year: 1960, max_year: 2015 }
    actual = HumanQuery.new(params).build
    expected = [{range: {year:{ lte: 2015, gte: 1960, execution: "fielddata"}}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_range_blank_values_should_be_ignored
    params = { min_year: 1960, max_year: 2015, max_revenue: "", min_revenue: "  " }
    actual = HumanQuery.new(params).build
    expected = [{range: {year:{ lte: 2015, gte: 1960, execution: "fielddata"}}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_empty_range
    params = {}
    actual = HumanQuery.new(params).build
    assert_equal Elasticquery::Query::DEFAULT, actual
  end

  def test_multiple_ranges
    params = { min_year: 1960, max_year: 2015, min_revenue: 100 }
    actual = HumanQuery.new(params).build
    expected = [{range: {year:{ lte: 2015, gte: 1960, execution: "fielddata"}}}, {range: {revenue: {gte: 100}}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end
end
