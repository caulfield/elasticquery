require "test_helper"
require "elasticquery/base"

class TestBase < MiniTest::Test

  def setup
    @klass = Class.new(Elasticquery::Base)
    @klass.filtered { 1 + 1 }

    @query = @klass.new
  end

  def test_queries_with_filters_are_filterable
    assert @query.filterable?
  end

  def test_queries_without_filters_are_not_filtrable
    klass = Class.new(Elasticquery::Base)
    refute klass.new.filterable?
  end

  def test_filters_is_empty_by_default
    query = Elasticquery::Base.new
    assert_empty query.rules
  end

  def test_extract_params
    query = @klass.new a: 1
    assert_equal 1, query.params[:a]
  end

  def test_default_params_as_empty
    assert_empty @query.params
  end

  def test_filters_proc
    assert_equal 2, @query.rules.first.call
  end

  def test_should_have_term_rule_included
    assert_respond_to @query, :term
  end

  def test_rules_as_array
    klass = Class.new(Elasticquery::Base)
    klass.filtered { 1 + 1 }
    klass.filtered { 2 + 2 }

    query = klass.new
    assert_equal 2, query.rules.count
  end

  def test_should_execute_code_in_instance_context
    klass = Class.new(Elasticquery::Base)
    klass.send(:define_method, :_error_) { raise StandardError, "from instance context"}
    klass.filtered { _error_ }

    assert_raises(StandardError) { klass.new.build }
  end

  def test_build_should_build_on_instance
    @klass.stub :build, {query: 1} do
      assert_equal @klass.build({a: 1}), query: 1
    end
  end
end
