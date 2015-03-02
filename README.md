# Elasticquery

[![Gem Version](https://badge.fury.io/rb/elasticquery.svg)](http://badge.fury.io/rb/elasticquery)
[![Build Status](https://travis-ci.org/caulfield/elasticquery.svg?branch=master)](https://travis-ci.org/caulfield/elasticquery)
[![Code Climate](https://codeclimate.com/github/caulfield/elasticquery/badges/gpa.svg)](https://codeclimate.com/github/caulfield/elasticquery)
[![Test Coverage](https://codeclimate.com/github/caulfield/elasticquery/badges/coverage.svg)](https://codeclimate.com/github/caulfield/elasticquery)

A module for elasticquery ruby [libraries][elasticsearch_rails] for using user-friendly query generator. [Click here to view demo with code examples.][demo]

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

Elasticsearch was designed to be customized as you need to. Providing simple methods it allows you to build power and flexible form objects. For example:

```ruby
class MyQuery < Elasticquery::Base
  filtered do |params|
     search params[:query]
     term user_id: params[:user_id] if params[:user_id].present?
     range.not :age, gte: 18
  end
end
```

Then use it

```ruby
query = MyQuery.new query: 'i typed', user_id: 5
query.build # => query for elasticsearch
Article.search query.build # => be happy 
```
### Currently you have

1. [Term][es_term] filter. [Usage][term_examples]
2. [MultiMatch][es_search] filter. [Usage][search_examples]
3. [Range][es_range] filter. [Usage][range_examples]  

#### Note! After first releases of elasticuqery it has scarce support of options and methods. Pull requests and issues with your ideas are welcome!

### Extended instruction
There are multiple ways to organize your query, using chaining calls, or custom filters. Better custom filters support in progress now.

- Chain calls
```ruby
PeopleQuery.new.search('hi', operator: :or).term(age: 21).build # => es-ready query
```
- Class methods
```ruby
class PeopleQuery < Elasticquery::Base
  filtered do |params|
     range :age, lte: prepare_age(params[:max_age])
  end

  protected

  def prepare_age(param)
    param.to_i
  end
end
PeopleQuery.build(max_age: '42') # => es-ready
```
- Multiple `filtered` blocks
```ruby
class ChildQuery < Elasticquery::Base
  filtered do |params|
    term :'category.id' => params[:category_id]
  end

  filtered do |params|
    term :'author.name' => User.find(params[:user_id]).name
  end
end
ChildQuery.build({user_id: 1, category_id: 14}) => # ;)

```
- Query inheritance
```ruby
class ParentQuery < Elasticquery::Base
  filtered do |params|
    term :'category.id' => params[:category_id]
  end
end

class ChildQuery < ParentQuery
  filtered do |params|
    term :'author.name' => User.find(params[:user_id]).name
  end
end

ChildQuery.build({user_id: 1, category_id: 14}) => # the same as in previous example
```
- Custom filter methods
```ruby
in progress...
```

- Custom filter classes
```ruby
in progress...
```

### Usage
#### term

```ruby
# Simple one term filter
term category: 'Rock'

# Multiple filters joined by AND condition
term category: 'Soul', user: 'Aaron'

# Term exclusion
term.not category: 'Rap'
```

#### search (multimatch)
```ruby
# Simple all fields search in your index
search 'developers'

# The same as above
search 'developers', fields: "_all", operator: "and", type: "best_fields"

# Configure fields
search 'Jordan', fields: ['first_name', 'last_name'], operator: "or"
```

#### range
```ruby
# One side range
range :age, gte: 18

# Double sides range
range :volume, gte: 1, lte: 100

# Range exclusion
range.not :size, gte: 32, lte: 128
```

## Contributing
1. I'm happy to see any method you can be part of this.


[elasticsearch_rails]: https://github.com/elasticsearch/elasticsearch-rails
[demo]: http://elasticquery-demo.herokuapp.com
[bundler]: http://bundler.io/
[rubygems]: https://rubygems.org/
[es_term]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-term-filter.html
[es_search]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html
[es_range]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-range-query.html
[term_examples]: #
[search_examples]: #
[range_examples]: #
