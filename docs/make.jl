using PredicateComposition
using Documenter

makedocs(;
    modules=[PredicateComposition],
    authors="Johannes Feist <johannes.feist@gmail.com> and contributors",
    repo="https://github.com/jfeist/PredicateComposition.jl/blob/{commit}{path}#L{line}",
    sitename="PredicateComposition.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jfeist.github.io/PredicateComposition.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jfeist/PredicateComposition.jl",
)
