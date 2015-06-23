require "test_helper"
require "elasticquery"

class TestTermsCase < MiniTest::Test
  class PostQuery < Elasticquery::Base
    filtered do |params|
      filters do
        terms id: params[:id], name: params[:name]
      end
    end
  end

  class OverridedPostQuery < PostQuery
    filtered do
      filters do
        term.not status: "pending"
        where.not status: "waiting", status: params[:inactive_status]
      end
      queries do
        search params[:q]
      end
    end
  end

  def test_individual_terms_filter
    params = {id: 1, name: "name"}
    actual = PostQuery.new(params).build
    expected = [{terms: {id: 1, name: "name"}}]
    assert_equal expected, actual[:query][:filtered][:filter][:and]
  end

  def test_with_other_rules
    params = {id: 1, name: "name", inactive_status: "closed", q: "Hello"}
    actual = OverridedPostQuery.new(params).build

    expected_query = {multi_match: {fields: "_all", operator: "and", type: "best_fields", query: "Hello"}}
    expected_filters = [{:terms=>{:id=>1, :name=>"name"}}, {:not=>{:filter=>{:term=>{:status=>"pending"}}}}, {:not=>{:filter=>{:terms=>{:status=>"closed"}}}}]

    assert_equal expected_query, actual[:query][:filtered][:query][:bool][:must][0]
    assert_equal expected_filters, actual[:query][:filtered][:filter][:and]
  end

  def test_empty_params_skipping
    params = {id: 1}
    actual = OverridedPostQuery.new(params).build
    expected_filters = [{terms: {id: 1}}, {not: {filter: {term: {status: "pending"}}}}]
    assert_equal expected_filters, actual[:query][:filtered][:filter][:and]
  end
end
