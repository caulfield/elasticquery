require "test_helper"
require "elasticquery"

class TestQueriesInheritence < MiniTest::Test
  class MultipleFilteredQuery < Elasticquery::Base
    filtered do |params|
      term :"category.id" => params[:category_id]
    end

    filtered do |params|
      term :"author.name" => params[:author_name]
    end
  end

  class ParentPostQuery < Elasticquery::Base
    filtered do |params|
      term :"category.id" => params[:category_id]
    end
  end

  class ChildPostQuery < ParentPostQuery
    filtered do |params|
      term :"author.name" => params[:author_name]
    end
  end

  def setup
    @params = {category_id: 1, author_name: "Sergey"}
  end

  def test_parent_subqueries_builder
    query = ParentPostQuery.new @params
    actual = query.build
    expected = [{term: {:"category.id" => 1}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_child_query_builder
    query = ChildPostQuery.new @params
    actual = query.build
    expected = [{term: {:"category.id" => 1}}, {term: {:"author.name" => "Sergey"}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_concatenate_all_filters
    actual = MultipleFilteredQuery.new(@params).build
    expected = [{term: {:"category.id" => 1}}, {term: {:"author.name" => "Sergey"}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end
end
