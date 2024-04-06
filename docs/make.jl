using SwarmMakie
using Documenter, DocumenterVitepress, Literate
using CairoMakie

CairoMakie.activate!(type="svg", pt_per_unit = 0.75)

DocMeta.setdocmeta!(SwarmMakie, :DocTestSetup, :(using SwarmMakie); recursive=true)

ENV["DATADEPS_ALWAYS_ACCEPT"] = true

# Now, we convert the source code to markdown files using Literate.jl
source_path = joinpath(dirname(@__DIR__), "src")
output_path = joinpath(@__DIR__, "src", "source")
mkpath(output_path)

literate_pages = Any[]

# We don't want Literate to convert the code into Documenter blocks, so we use a custom postprocessor
# to add the `@meta` block to the markdown file, which will be used by Documenter to add an edit link.
function _add_meta_edit_link_generator(path)
    return function (input)
        return """
        ```@meta
        EditURL = "$(path).jl"
        ```

        """ * input # we add `.jl` because `relpath` eats the file extension, apparently :shrug:
    end
end

# First letter of `str` is made uppercase and returned
ucfirst(str::String) = string(uppercase(str[1]), str[2:end])

function process_literate_recursive!(pages::Vector{Any}, path::String; source_path, output_path)
    if isdir(path)
        contents = []
        process_literate_recursive!.((contents,), normpath.(readdir(path; join = true)); source_path, output_path)
        push!(pages, ucfirst(splitdir(path)[2]) => contents)
    elseif isfile(path)
        if endswith(path, ".jl")
            relative_path = relpath(path, source_path)
            output_dir = joinpath(output_path, splitdir(relative_path)[1])
            Literate.markdown(
                path, output_dir; 
                flavor = Literate.CommonMarkFlavor(), 
                postprocess = _add_meta_edit_link_generator(joinpath(relpath(source_path, output_dir), relative_path))
            )
            push!(pages, joinpath("source", splitext(relative_path)[1] * ".md"))
        end
    end
end

withenv("JULIA_DEBUG" => "Literate") do # allow Literate debug output to escape to the terminal!
    global literate_pages
    vec = []
    process_literate_recursive!(vec, source_path; source_path, output_path)
    literate_pages = vec[1][2] # this is a hack to get the pages in the correct order, without an initial "src" folder.  
    # TODO: We should probably fix the above in `process_literate_recursive!`.
end

# As a special case, literatify the examples.jl file in docs/src to Documenter markdown
Literate.markdown(joinpath(@__DIR__, "src", "examples", "examples.jl"), joinpath(@__DIR__, "src", "examples"); flavor = Literate.DocumenterFlavor())

makedocs(;
    modules=[SwarmMakie],
    authors="Anshul Singhvi <anshulsinghvi@gmail.com>, Jacob Zelko <jacobszelko@gmail.com>, Michael Krabbe Borregaard <mkborregaard@snm.ku.dk>, and contributors",
    sitename="SwarmMakie.jl",
    format=DocumenterVitepress.MarkdownVitepress(;
        repo = "https://github.com/asinghvi17/SwarmMakie.jl",
        devurl = "dev",
        devbranch = "main",
    ),
    pages=[
        "Introduction" => "introduction.md",
        "Algorithms" => "algorithms.md",
        "Gutters" => "gutters.md",
        "Examples" => [
            "examples/examples.md",
            "Nonlinear scales" => "examples/scales.md",
            "Unconventional use" => "examples/unconventional.md"
        ],
        "API Reference" => "api.md",
        "Source code" => literate_pages,
    ],
    warnonly = true,
)

deploydocs(;
    repo="github.com/asinghvi17/SwarmMakie.jl",
    devbranch="main",
    push_preview = true,
)
