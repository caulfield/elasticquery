# Elasticquery

[![Gem Version](https://badge.fury.io/rb/elasticquery.svg)](http://badge.fury.io/rb/elasticquery)
[![Build Status](https://travis-ci.org/caulfield/elasticquery.svg?branch=master)](https://travis-ci.org/caulfield/elasticquery)
[![Code Climate](https://codeclimate.com/github/caulfield/elasticquery/badges/gpa.svg)](https://codeclimate.com/github/caulfield/elasticquery)
[![Test Coverage](https://codeclimate.com/github/caulfield/elasticquery/badges/coverage.svg)](https://codeclimate.com/github/caulfield/elasticquery)

A module for elasticsearch-rails [libraries][elasticsearch_rails] like as user-friendly query generator.

## Instalation

To install using [Bundler][bundler] grab the latest stable version:

```ruby
gem 'elasticquery'
```
To manually install `elasticquery` via [Rubygems][rubygems] simply gem install:

```bash
gem install elasticquery
```

## Getting Started
### First instruction

Elasticquery was designed to be customized as you need to. Providing simple methods it allows you to build flexible queries using [Elastiq Query DSL][elastic_query_dsl]

```ruby
class MyQuery < Elasticquery::Base
  filtered do |params|
    filters do
      term "user.id" => params[:user_id]
      range.not :age, gte: 18
    end
    queries do
      multi_match params[:query]
    end
  end
end
```

```ruby
query = MyQuery.new query: 'i typed', user_id: 5
query.build # => query for elastic
Article.search query.build # => returns result 
```

## Currently you have
### Filters
  #### [Term][es_term]


  ```ruby
  # Simple one term filter
  term category: 'Rock'

  # _cache option support
  term category: 'Soul', _cache: false

  # Blank values are skipped. This query returns all records
  term name: " "
  ```
  #### [Range][es_range]


  ```ruby
  # One side range
  range :age, gte: 18

  # Double sides range
  range :volume, gte: 1, lte: 100

  # _cache and execution options support
  range :volume, gte: 1, lte: 100, _cache: true, execution: "fielddata"
  ```
  #### [Not][es_not]

  ```ruby
  # Blank values are skipped. This query returns all records
  range.not :age, lte: ' ', gte: nil

  # Term exclusion
  term.not category: 'Rap'
  ```

All filters are joined by **AND** filter.
## Queries
  1. [MultiMatch][es_search]


  ```ruby
  # Simple all fields search in your index
  multi_match 'developers'

  # The same as above
  multi_match 'developers', fields: "_all", operator: "and", type: "best_fields"

  # Configure fields
  multi_match 'Jordan', fields: ['first_name', 'last_name'], operator: "or"

  # Blank values are skipped. This query returns all records
  multi_match ''

  # Alias as search
  search 'Hello!'
  ```

### Extended instruction
There are multiple ways to organize your query, using chaining calls, or custom filters.

- Chain calls
```ruby
PeopleQuery.new.queries.multi_match('hi', operator: :or).filters.term(age: 21).build # => returns hash
Query.new.queries./queries-chain/.filters./filters-chain/
```

- Class methods

```ruby
class PeopleQuery < Elasticquery::Base
  filtered do |params|
    filters do
      range :age, lte: prepare_age(params[:max_age])
    end
  end

  protected

  def prepare_age(param)
    param.to_i
  end
end
PeopleQuery.build(max_age: '42') # => result
```

- Multiple `filtered` blocks

```ruby
class ChildQuery < Elasticquery::Base
  filtered do |params|
    filters do
      term :'category.id' => params[:category_id]
    end
  end

  filtered do |params|
    filters do
      term :'author.id' => User.find(params[:user_id]).name
    end
  end
end
ChildQuery.build({user_id: 1, category_id: 14}) => returns both user and category filters
```

- Query inheritance

```ruby
class ParentQuery < Elasticquery::Base
  filtered do |params|
    filters do
      term :'category.id' => params[:category_id]
    end
  end
end

class ChildQuery < ParentQuery
  filtered do |params|
    filters do
      term :'author.id' => User.find(params[:user_id]).name
    end
  end
end

ChildQuery.build({user_id: 1, category_id: 14}) => # the same as in previous example
```

[elasticsearch_rails]: https://github.com/elasticsearch/elasticsearch-rails
[demo]: http://elasticquery-demo.herokuapp.com
[bundler]: http://bundler.io/
[rubygems]: https://rubygems.org/
[es_term]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-term-filter.html
[es_not]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-not-filter.html
[es_search]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html
[es_range]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-range-query.html
[elastic_query_dsl]: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html
