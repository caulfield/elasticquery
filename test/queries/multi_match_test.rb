require "test_helper"
require "elasticquery/queries/multi_match"

class TestMultiMatchQuery < MiniTest::Test

  def test_default_values_of_filter
    filter = Elasticquery::Queries::MultiMatch.new "hi"
    assert_equal filter.to_hash, {multi_match: {fields: "_all", operator: "and", type: "best_fields", query: "hi"}}
  end

  def test_passed_parameters
    assert_raises ArgumentError do
      Elasticquery::Queries::MultiMatch.new
    end
  end

  def test_empty_query_is_invalid
    filter = Elasticquery::Queries::MultiMatch.new "  "
    assert filter.invalid?
  end

  def test_default_query_should_be_valid
    filter = Elasticquery::Queries::MultiMatch.new "hi"
    assert filter.valid?
  end

  def test_query_fields_validation
    filter = Elasticquery::Queries::MultiMatch.new "hi", fields: 42
    refute filter.valid?
    filter = Elasticquery::Queries::MultiMatch.new "hi", fields: %w(name body)
    assert filter.valid?
  end

  def test_operator_validation
    filter = Elasticquery::Queries::MultiMatch.new "hi", operator: "without"
    refute filter.valid?
    filter = Elasticquery::Queries::MultiMatch.new "hi", operator: "or"
    assert filter.valid?
  end

  def test_types_validation
    %w(most_fields cross_fields phrase pharse_prefix).each do |type|
      filter = Elasticquery::Queries::MultiMatch.new "hi", type: type
      assert filter.valid?
    end
    filter = Elasticquery::Queries::MultiMatch.new "hi", type: "random"
    refute filter.valid?
  end
end
