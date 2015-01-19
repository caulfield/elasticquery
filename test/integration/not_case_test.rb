require 'test_helper'
require 'elasticquery'

class TestNotCase < MiniTest::Test
  class PostQuery < Elasticquery::Base
    filtered do |param|
      term.not id: params[:id]
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
end
