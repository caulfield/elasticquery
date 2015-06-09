require "test_helper"
require "elasticquery/filters/not"

class NotFilter < MiniTest::Test
  attr_reader :filters

  def setup
    @filter = Elasticquery::Filters::Not.new a: 1
  end

  def test_always_valid
    filter = Elasticquery::Filters::Not.new
    assert filter.valid?
  end

  def test_to_hash_return_proc
    assert_instance_of Proc, @filter.to_hash
  end

  def test_to_hash_change_last_term_filter_value
    filter_class = MiniTest::Mock.new
    filter_class.expect :valid?, true
    expected = {query: {filtered: {filter: {and: [{term: {a: 1, b: 2}}]}}}}
    filter_class.expect :to_hash, expected
    previous_filter = MiniTest::Mock.new
    previous_filter.expect :dup_with, filter_class, [{a: 1}]

    @filters = [previous_filter]
    result = instance_exec &@filter.to_hash
    expected = {query: {filtered: {filter: {and: [{not: {filter: {term: {a: 1, b: 2}}}}]}}}}
    assert_equal result, expected

    assert filter_class.verify
    assert previous_filter.verify
  end

  def test_to_hash_change_last_range_filter_value
    filter_class = MiniTest::Mock.new
    filter_class.expect :valid?, true
    expected = {query: {filtered: {filter: {and: [{range: {a: {lte: 1}}}]}}}}
    filter_class.expect :to_hash, expected
    previous_filter = MiniTest::Mock.new
    previous_filter.expect :dup_with, filter_class, [{a: 1}]

    @filters = [previous_filter]
    result = instance_exec &@filter.to_hash
    expected = {query: {filtered: {filter: {and: [{not: {filter: {range: {a: {lte: 1}}}}}]}}}}
    assert_equal result, expected

    assert filter_class.verify
    assert previous_filter.verify
  end

  def test_based_new_raise_exception
    assert_raises StandardError do
      @filter.dup_with a: 1
    end
  end
end
