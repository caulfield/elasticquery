require 'test_helper'
require 'elasticquery/filters/search'

class TestSearchFilter < MiniTest::Test

  def test_default_values_of_filter
    filter = Elasticquery::Filters::Search.new 'hi'
    actual = filter.to_hash[:query][:filtered][:query][:multi_match]
    assert_equal actual, {fields: "_all", operator: "and", type: "best_fields", query: "hi"}
  end

  def test_passed_parameters
    assert_raises ArgumentError do
      Elasticquery::Filters::Search.new
    end
  end

  def test_default_query_should_be_valid
    filter = Elasticquery::Filters::Search.new 'hi'
    assert filter.valid?
  end

  def test_query_fields_validation
    filter = Elasticquery::Filters::Search.new 'hi', fields: 42
    refute filter.valid?
    filter = Elasticquery::Filters::Search.new 'hi', fields: %w(name body)
    assert filter.valid?
  end

  def test_operator_validation
    filter = Elasticquery::Filters::Search.new 'hi', operator: 'without'
    refute filter.valid?
    filter = Elasticquery::Filters::Search.new 'hi', operator: 'or'
    assert filter.valid?
  end

  def test_types_validation
    %w(most_fields cross_fields phrase pharse_prefix).each do |type|
      filter = Elasticquery::Filters::Search.new 'hi', type: type
      assert filter.valid?
    end
    filter = Elasticquery::Filters::Search.new 'hi', type: 'random'
    refute filter.valid?
  end

  def test_to_hash_is_empty_if_invalid
    filter = Elasticquery::Filters::Search.new 'hi', fields: 42
    refute filter.valid?
    assert_equal filter.to_hash, {}
  end

  def test_dup_with_return_new_search_query
    filter = Elasticquery::Filters::Search.new 'hi', fields: 42
    new_filter = filter.dup_with 'who'
    assert_kind_of Elasticquery::Filters::Search, new_filter
  end
end
