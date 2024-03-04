using SwarmMakie
using Documenter, DocumenterVitepress

DocMeta.setdocmeta!(SwarmMakie, :DocTestSetup, :(using SwarmMakie); recursive=true)

makedocs(;
    modules=[SwarmMakie],
    authors="Anshul Singhvi <anshulsinghvi@gmail.com>, Jacob Zelko <jacobszelko@gmail.com>, Michael Krabbe Borregaard <mkborregaard@snm.ku.dk>, and contributors",
    sitename="SwarmMakie.jl",
    format=DocumenterVitepress.MarkdownVitepress(;
        repo = "https://github.com/asinghvi17/SwarmMakie.jl",
        devurl = "dev",
    ),
    pages=[
        "Introduction" => "introduction.md",
    ],
)

deploydocs(;
    repo="github.com/asinghvi17/SwarmMakie.jl",
    devbranch="main",
)
