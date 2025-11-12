using SwarmMakie
using Documenter, DocumenterVitepress
using CairoMakie

DocMeta.setdocmeta!(SwarmMakie, :DocTestSetup, :(using SwarmMakie); recursive=true)

is_ci() = get(ENV, "CI", "false") == "true"

makedocs(;
    modules=[SwarmMakie],
    authors="Anshul Singhvi <anshulsinghvi@gmail.com>, Jacob Zelko <jacobszelko@gmail.com>, Michael Krabbe Borregaard <mkborregaard@snm.ku.dk>, and contributors",
    sitename="SwarmMakie.jl",
    format=DocumenterVitepress.MarkdownVitepress(;
        repo = "https://github.com/MakieOrg/SwarmMakie.jl",
        devurl = "dev",
        devbranch = "main",
        (is_ci() ? (;) : (; deploy_url = ""))..., # without deploy_url="" locally the build is broken due to a SwarmMakie.jl prefix
    ),
    pages=[
        "Introduction" => "introduction.md",
        "Algorithms" => "algorithms.md",
        "Examples" => [
            "examples/examples.md",
            "Nonlinear scales" => "examples/scales.md",
            "Unconventional use" => "examples/unconventional.md"
        ],
        "API Reference" => "api.md",
    ],
    warnonly = !is_ci(),
)

DocumenterVitepress.deploydocs(;
    repo="github.com/MakieOrg/SwarmMakie.jl",
    devbranch="main",
    push_preview = true,
)
