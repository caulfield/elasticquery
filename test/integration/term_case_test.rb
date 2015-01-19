require 'test_helper'
require 'elasticquery'

class TestTermCase < MiniTest::Test
  class PostQuery < Elasticquery::Base
    filtered do |params|
      term :'category.id' => params[:category_id], :"author.name" => params[:author_name]
    end
  end

  def test_multiple_valid_terms
    params = {category_id: 1, author_name: 'Sergey'}
    actual = PostQuery.new(params).build
    expected = [{term: {:"category.id" => 1}}, {term: {:"author.name" => 'Sergey'}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_extra_params
    params = { category_id: 1, author_name: 'Sergey', a: 1 }
    actual = PostQuery.new(params).build
    expected = [{term: {:"category.id" => 1}}, {term: {:"author.name" => 'Sergey'}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end
end
