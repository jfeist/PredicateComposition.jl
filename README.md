# PredicateComposition

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jfeist.github.io/PredicateComposition.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jfeist.github.io/PredicateComposition.jl/dev)
[![Build Status](https://travis-ci.com/jfeist/PredicateComposition.jl.svg?branch=master)](https://travis-ci.com/jfeist/PredicateComposition.jl)
[![Coverage](https://codecov.io/gh/jfeist/PredicateComposition.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jfeist/PredicateComposition.jl)

This package defines some functions that do logical composition of predicate functions (i.e., functions that return a boolean). These are higher-order functions, i.e., functions that take functions as arguments and return a new function. Julia implements them efficiently. This permits a compact notation for selecting specific elements out of collections. 

## Logical compositions
```julia
AND(f1,f2) = (args...) -> f1(args...) && f2(args...)
OR(f1,f2) = (args...) -> f1(args...) || f2(args...)
```

## Numerical comparisons

These functions give functions that compare the output values of different functions. The last three (`MAX`, `MIN`, `SUM`) can take an arbitrary number of arguments.

```julia
ISEQUAL(f1,f2) = (args...) -> f1(args...) == f2(args...)
ISLESS(f1,f2) = (args...) -> f1(args...) < f2(args...)
ISLESSEQ(f1,f2) = (args...) -> f1(args...) ≤ f2(args...)
ISGREATER(f1,f2) = (args...) -> f1(args...) > f2(args...)
ISGREATEREQ(f1,f2) = (args...) -> f1(args...) ≥ f2(args...)

MAX(fs...) = (args...) -> max((f(args...) for f in fs)...)
MIN(fs...) = (args...) -> min((f(args...) for f in fs)...)
SUM(fs...) = (args...) -> +((f(args...) for f in fs)...)
```


## Aliases

For convenient typing, we also define the following aliases:

- `⩓ = AND` (type with `\And<Tab>`)
- `⩔ = OR` (type with `\Or<Tab>`)
- `≣ = ISEQUAL` (type with `\Equiv<Tab>`)
- `≺ = ISLESS` (type with `\prec<Tab>`)
- `⪯ = ISLESSEQ` (type with `\preceq<Tab>`)
- `≻ = ISGREATER` (type with `\succ<Tab>`)
- `⪰ = ISGREATEREQ` (type with `\succeq<Tab>`)

The `MAX` and `MIN` functions are special in that they combine numerical results of different functions, not booleans. For example, if we have functions `count_apples`, `count_oranges`, and `count_lemons` that count the number of apples, oranges, and lemons in some data structure describing a fruit basket, we can do
```julia
filter(MAX(count_apples,count_oranges,count_lemons) ⪰ 3, fruit_baskets)
```
instead of 
```julia
filter(x -> max(count_apples(x),count_oranges(x),count_lemons(x)) ⪰ 3, fruit_baskets)
```
to get all fruit baskets with at least three 


## Example

```julia
length_from_3_to_5 = (length ⪰ 3) ⩓ (length ⪯ 5)
```
which is equivalent to
```julia
length_from_3_to_5(x) = length(x) ≥ 3 && length(x) ≤ 5
```
The compact notation in particular is advantageous for passing as a function argument to `filter` and similar functions, compare
```julia
filter((length ⪰ 3) ⩓ (length ⪯ 5), collection)
```
to
```julia
filter(x -> length(x) ≥ 3 && length(x) ≤ 5, collection)
```



**CAUTION**: The operators `⩓` and `⩔`, although they do not have predefined meaning, have the precedence of addition operators, which is higher than comparison operators like `≻` and `≺`.
So a statement like `length ≻ 2 ⩓ length ≺ 7` would be parsed as `length ≻ (2 ⩓ length) ≺ 7`, i.e., the function `x -> length(x) > (2(x) && length(x)) < 7(x)`, instead of the probably desired `x -> (length(x) > 2) && (length(x) < 7)`.
So to logically compose functions like this, you have to explicitly add parentheses, e.g., `(length ≻ 2) ⩓ (length ≺ 7)`.

For a complete list of operator precedence rules, see https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm.