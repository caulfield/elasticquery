require 'test_helper'
require 'elasticquery'

class TestNotCase < MiniTest::Test
  class PostQuery < Elasticquery::Base
    filtered do |param|
      term.not id: params[:id]
    end
  end

  class PostRangeQuery < Elasticquery::Base
    filtered do |param|
      term published: true
      range.not lte: params[:year]
    end
  end

  class InvalidQuery < Elasticquery::Base
    filtered do |param|
      term.not
    end
  end

  def test_invalid_previous_filter
    query = InvalidQuery.new({}).build
    assert_equal query, {}
  end

  def test_term_case
    params = {id: 1}
    actual = PostQuery.new(params).build
    expected = [{not: {filter: {term: {id: 1}}}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def range_case
    params = {year: 2015}
    actual = PostRangeQuery.new(params).build
    expected = [{not: {filter: {range: {lte: 2015}}}}, {term: {published: true}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end
end
