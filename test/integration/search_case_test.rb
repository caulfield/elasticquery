require 'test_helper'
require 'elasticquery'

class TestSearchQueryCase < MiniTest::Test
  class PostQuery < Elasticquery::Base
    filtered do |params|
      term :'category' => params[:category]
      search params[:search]
    end
  end

  class PostOptionsQuery < Elasticquery::Base
    filtered do |params|
      search params[:search],
        fields: params[:fields],
        operator: params[:operator],
        type: "phrase"
    end
  end

  class MultipleSearch < PostQuery
    filtered do |params|
      search "look for"
    end
  end

  def test_search_with_other_query
    params = {category: 'zoo', search: 'hello'}
    actual = PostQuery.new(params).build
    expected_term = [{term: {category: 'zoo'}}]
    assert_equal expected_term, actual[:query][:filtered][:filter][:and]
    expected_search = { query: 'hello', fields: "_all", operator: 'and', type: 'best_fields'}
    assert_equal expected_search, actual[:query][:filtered][:query][:multi_match]
  end

  def test_all_options_to_configure
    params = {search: 'hello', fields: %w(title body), operator: 'or'}
    actual = PostOptionsQuery.new(params).build
    expected = {fields: %w(title body), operator: "or", type: "phrase", query: 'hello'}
    assert_equal expected, actual[:query][:filtered][:query][:multi_match]
  end

  def test_multiple_search_use_last_search_declaration
    params = {search: 'hello'}
    actual = MultipleSearch.new(params).build
    assert_equal "look for", actual[:query][:filtered][:query][:multi_match][:query]
  end
end
