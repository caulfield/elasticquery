require "test_helper"
require "elasticquery"

class TestNotCase < MiniTest::Test
  class PostQuery < Elasticquery::Base
    filtered do |param|
      filters do
        term.not id: params[:id]
      end
    end
  end

  class PostRangeQuery < Elasticquery::Base
    filtered do |param|
      filters do
        term published: true
        range.not :age, lte: params[:year], _cache: false
      end
    end
  end

  class InvalidQuery < Elasticquery::Base
    filtered do |param|
      filters do
        term.not
      end
    end
  end

  def test_invalid_previous_filter
    query = InvalidQuery.new({}).build
    assert_equal Elasticquery::Query::DEFAULT, query
  end

  def test_term_case
    params = {id: 1}
    actual = PostQuery.new(params).build
    expected = [{not: {filter: {term: {id: 1}}}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_range_case
    params = {year: 2015}
    actual = PostRangeQuery.new(params).build
    expected = [{term: {published: true}}, {not: {filter: {range: {age: {lte: 2015, _cache: false}}}}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end
end
