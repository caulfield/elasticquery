require "test_helper"
require "elasticquery"

class TestSearchQueryCase < MiniTest::Test
  class PostQuery < Elasticquery::Base
    filtered do |params|
      filters do
        term :"category" => params[:category]
      end
      queries do
        search params[:search]
      end
    end
  end

  class PostOptionsQuery < Elasticquery::Base
    filtered do |params|
      queries do
        search params[:search],
          fields: params[:fields],
          operator: params[:operator],
          type: "phrase"
      end
    end
  end

  class MultipleSearch < PostQuery
    filtered do |params|
      queries do
        search "look for"
      end
    end
  end

  def test_search_with_other_query
    params = {category: "zoo", search: "hello"}
    actual = PostQuery.new(params).build
    expected_term = [{term: {category: "zoo"}}]
    assert_equal expected_term, actual[:query][:filtered][:filter][:and]
    expected_search = { query: "hello", fields: "_all", operator: "and", type: "best_fields"}
    assert_equal expected_search, actual[:query][:filtered][:query][:bool][:must][0][:multi_match]
  end

  def test_empty_search
    params = {search: "" , fields: %w(title body), operator: "or"}
    actual = PostOptionsQuery.new(params).build
    assert_equal Elasticquery::Query::DEFAULT, actual
  end

  def test_all_options_to_configure
    params = {search: "hello", fields: %w(title body), operator: "or"}
    actual = PostOptionsQuery.new(params).build
    expected = {fields: %w(title body), operator: "or", type: "phrase", query: "hello"}
    assert_equal expected, actual[:query][:filtered][:query][:bool][:must][0][:multi_match]
  end

  def test_multiple_searches_should_be_combined
    params = {search: "hello"}
    actual = MultipleSearch.new(params).build
    assert_equal "hello", actual[:query][:filtered][:query][:bool][:must][0][:multi_match][:query]
    assert_equal "look for", actual[:query][:filtered][:query][:bool][:must][1][:multi_match][:query]
  end
end
