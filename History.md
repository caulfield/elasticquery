## Elasticquery (master)

* Separate all filters to filters and queries. Rename search to multi_match. Change dsl for using explisit rule type.

* Add `terms` filter

* Add `exists` filter. `exists.not` works as `missing`.

## Elasticquery 0.1.2 (16 June 2015)

* Fix `range.not`. Exception was raised

* Skip blank values in filtering
`term name: "  "`, `range :age, lte: ""`, and `search nil` return all records

* Create `history.md` file

* Add options support for `range` and `term`.
`term` supports `_cache` option. `range` supports both `_cache` and `execution`

## Elasticquery 0.1.1 (02 Mar 2015)

* Fix typo in gem description
* Add rubygems bange

## Elasticquery 0.1.0 (02 Mar 2015)

* Initial version. Supported filters: `term`, `range`, `term.not`, `range.not`. Support multi match query. Simple inheritence support. Chain calls.
