require "test_helper"
require "elasticquery"

class TestTermCase < MiniTest::Test
  class PostQuery < Elasticquery::Base
    filtered do |params|
      filters do
        term :"category.id" => params[:category_id]
        term :"author.name" => params[:author_name], _cache: false
      end
    end
  end

  def test_multiple_valid_terms
    params = {category_id: 1, author_name: "Sergey"}
    actual = PostQuery.new(params).build
    expected = [{term: {:"category.id" => 1}}, {term: {:"author.name" => "Sergey", _cache: false}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_extra_params
    params = {category_id: 1, author_name: "Sergey", a: 1}
    actual = PostQuery.new(params).build
    expected = [{term: {:"category.id" => 1}}, {term: {:"author.name" => "Sergey", _cache: false}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_blank_values_should_be_ignored
    params = {category_id: 1, author_name: ""}
    actual = PostQuery.new(params).build
    expected = [{term: {:"category.id" => 1}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_empty_params
    params = {}
    actual = PostQuery.new(params).build
    assert_equal Elasticquery::Query::DEFAULT, actual
  end
end
