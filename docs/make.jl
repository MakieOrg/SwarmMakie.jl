using SwarmMakie
using Documenter

DocMeta.setdocmeta!(SwarmMakie, :DocTestSetup, :(using SwarmMakie); recursive=true)

makedocs(;
    modules=[SwarmMakie],
    authors="Anshul Singhvi <anshulsinghvi@gmail.com>, Jacob Zelko <jacobszelko@gmail.com>, Michael Krabbe Borregaard <mkborregaard@snm.ku.dk>, and contributors",
    sitename="SwarmMakie.jl",
    format=Documenter.HTML(;
        canonical="https://asinghvi17.github.io/SwarmMakie.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/asinghvi17/SwarmMakie.jl",
    devbranch="main",
)
