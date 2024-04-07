#=

# Figure blocks

The figure block is just a rejiggered example block, with the MIME-type set 

=#

"""
    abstract type FigureBlocks

This type encodes a block denoted by `@figure`.
"""
abstract type FigureBlocks <: Documenter.Expanders.NestedExpanderPipeline end


Documenter.Selectors.order(::Type{FigureBlocks})  = 8.0 # like @example
Documenter.Selectors.matcher(::Type{FigureBlocks},  node, page, doc) = Documenter.iscode(node, r"^@figure")

# TODO: we have to have a better / less fragile way to do this than plain text references!
module MakieDocsHelpers4
    struct AsMIME{M<:MIME,V}
        mime::M
        value::V
    end

    Base.show(io::IO, m::MIME, a::AsMIME{MIME}) where MIME = show(io, m, a.value)
end

function Documenter.Selectors.runner(::Type{FigureBlocks}, node, page, doc)
    el = node.element
    infoexpr = Meta.parse(el.info)
    args = infoexpr.args[3:end]
    if !isempty(args) && args[1] isa Symbol
        blockname = string(args[1])
        kwargs = args[2:end]
    else
        blockname = ""
        kwargs = args
    end
    kwargs = Dict(map(kwargs) do expr
        if !(expr isa Expr) && expr.head !== :(=) && length(expr.args) == 2 && expr.args[1] isa Symbol && expr.args[2] isa Union{String,Number,Symbol}
            error("Invalid keyword arg expression: $expr")
        end
        expr.args[1] => expr.args[2]
    end)
    el.info = "@example $blockname"
    el.code = transform_figure_code(el.code; kwargs...)
    Documenter.Selectors.runner(Documenter.Expanders.ExampleBlocks, node, page, doc)
end

function _mime_from_format(fmt::String, backend::Symbol)
    return if fmt in ("png", "jpeg") # these are supported by all backends!
        "image/$fmt"
    elseif fmt == "svg"
        @assert backend == :CairoMakie "Only CairoMakie can emit `$fmt` files.  Please either change the mime in your `@figure` block to a raster format like PNG, or change the backend to CairoMakie."
        "image/svg+xml"
    elseif fmt in ("pdf", "eps")
        @assert backend == :CairoMakie "Only CairoMakie can emit `$fmt` files.  Please either change the mime in your `@figure` block to a raster format like PNG, or change the backend to CairoMakie."
        "application/$fmt"
    elseif fmt == "html"
        @assert backend == :WGLMakie "Only WGLMakie can emit `$fmt` files.  Please either change the mime in your `@figure` block to a raster format like PNG, or change the backend to WGLMakie."
        "text/html"
    else
        error("Unknown format `$fmt` detected.")
    end
end

function transform_figure_code(code::String; backend::Symbol = :CairoMakie, type = "png", kwargs...)
    backend in (:CairoMakie, :GLMakie, :WGLMakie, :RPRMakie) || error("Invalid backend $backend")
    mimetype = _mime_from_format(type, backend)
    # All this code is within the Documenter runner module's scope, so we have to go up one level to go to Main.
    # I am wondering if, in theory, we should actually just access Main directly?
    """
    import $backend # hide
    $(backend).activate!() # hide
    import Main.MakieDocsHelpers4 # hide
    var"#result" = begin # hide
    $code
    end # hide
    if var"#result" isa Makie.FigureLike # hide
        MakieDocsHelpers4.AsMIME(MIME"$mimetype"(), var"#result") # hide
    else # hide
        var"#result" # hide
    end # hide
    """
end