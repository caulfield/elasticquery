require "test_helper"
require "elasticquery/filters/term"

class TestTermFilter < MiniTest::Test

  def test_valid_filter_should_have_one_key
    filter = Elasticquery::Filters::Term.new a: 1
    assert filter.valid?
  end

  def test_invalid_filter_should_have_no_keys
    filter = Elasticquery::Filters::Term.new
    refute filter.valid?
  end

  def test_invalid_filter_should_have_2_and_more_keys
    filter = Elasticquery::Filters::Term.new  a: 1, b: 2
    refute filter.valid?
  end

  def test_empty_condition_is_invalid
    filter = Elasticquery::Filters::Term.new a: ""
    refute filter.valid?
  end

  def test_valid_filter_could_have_cache_option
    filter = Elasticquery::Filters::Term.new  a: 1, _cache: false
    assert filter.valid?
  end

  def test_to_hash_should_pass__cache_options
    filter = Elasticquery::Filters::Term.new a: 1, _cache: true
    assert_equal({term: {a: 1, _cache: true}}, filter.to_hash)
  end

  def test_to_hash_should_return_es_query
    filter = Elasticquery::Filters::Term.new a: 1
    assert_equal({term: {a: 1}}, filter.to_hash)
  end

  def test_not_to_hash_should_return_terms_not_query
    filter = Elasticquery::Filters::Term.new a: 1
    assert_equal({not: {filter: {term: {a: 1}}}}, filter.to_not_hash)
  end

  def test_dup_with_return_new_term_filter
    filter = Elasticquery::Filters::Term.new a: 1
    new_filter = filter.dup_with b: 2
    assert_kind_of Elasticquery::Filters::Term, new_filter
  end
end
