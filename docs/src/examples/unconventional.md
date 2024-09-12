# Unconventional swarm plots

You can use swarm plots to simply separate scatter markers which share the same `x` coordinate, and distinguish them by color and marker type.


## The Julia benchmark plot

```@example julia-benchmark
# Load the required Julia packages
using Base.MathConstants
using CSV
using DataFrames
using AlgebraOfGraphics, SwarmMakie, CairoMakie, MakieTeX
using StatsBase, CategoricalArrays

# Load benchmark data from file
benchmarks =
    CSV.read(download("https://raw.githubusercontent.com/JuliaLang/Microbenchmarks/master/bin/benchmarks.csv"), DataFrame; header = ["language", "benchmark", "time"])

# Capitalize and decorate language names from datafile
dict = Dict(
    "c" => "C",
    "julia" => "Julia",
    "lua" => "LuaJIT",
    "fortran" => "Fortran",
    "java" => "Java",
    "javascript" => "JavaScript",
    "matlab" => "Matlab",
    "mathematica" => "Mathematica",
    "python" => "Python",
    "octave" => "Octave",
    "r" => "R",
    "rust" => "Rust",
    "go" => "Go",
);
benchmarks[!, :language] = [dict[lang] for lang in benchmarks[!, :language]]

# Normalize benchmark times by C times
ctime = benchmarks[benchmarks[!, :language] .== "C", :]
benchmarks = innerjoin(benchmarks, ctime, on = :benchmark, makeunique = true)
select!(benchmarks, Not(:language_1))
rename!(benchmarks, :time_1 => :ctime)
benchmarks[!, :normtime] = benchmarks[!, :time] ./ benchmarks[!, :ctime];

# Compute the geometric mean for each language
langs = [];
means = [];
priorities = [];
for lang in benchmarks[!, :language]
    data = benchmarks[benchmarks[!, :language] .== lang, :]
    gmean = geomean(data[!, :normtime])
    push!(langs, lang)
    push!(means, gmean)
    if (lang == "C")
        push!(priorities, 1)
    elseif (lang == "Julia")
        push!(priorities, 2)
    else
        push!(priorities, 3)
    end
end

# Add the geometric means back into the benchmarks dataframe
langmean = Dict(langs .=> tuple.(means, priorities))
benchmarks.geomean = first.(getindex.((langmean,), benchmarks.language))
benchmarks.priority = last.(getindex.((langmean,), benchmarks.language))

# Put C first, Julia second, and sort the rest by geometric mean
sort!(benchmarks, [:priority, :geomean]);

langs = CategoricalArray(benchmarks.language)
bms = CategoricalArray(benchmarks.benchmark)

f, a, p = beeswarm(
    langs.refs, benchmarks.normtime;
    color = bms.refs,
    colormap = :Set2_8,
    # markersize = 5,
    marker = Circle,
    axis = (;
        yscale = log10,
        xticklabelrotation = 0, 
        xticklabelsize = 12,
        xticksvisible = false,
        topspinecolor = :gray,
        bottomspinecolor = :gray,
        leftspinecolor = :gray,
        rightspinecolor = :gray,
        ylabel = "Time relative to C",
        xticks = (1:length(unique(langs)), langs.pool.levels),
        xminorticks = IntervalsBetween(2),
        xgridvisible = false,
        xminorgridvisible = true,
        xminorgridcolor = (:black, 0.2),
        yminorticks = IntervalsBetween(5),
        yminorgridvisible = true,
    ),
    figure = (; size = (1000, 618),)
)
leg = Legend(f[1, 2],
    [MarkerElement(; color = Makie.categorical_colors(:Set1_8, 8)[i], marker = :circle, markersize = 11) for i in 1:length(bms.pool.levels)],
    bms.pool.levels,
    "Benchmark";
)
f

```


## Benchmarks colored by language

```@example julia-benchmark

f, a, p = beeswarm(
    bms.refs, benchmarks.normtime;
    color = langs.refs,
    colormap = Makie.Colors.distinguishable_colors(13),#:Set1_9,
    # markersize = 5,
    marker = Circle,
    axis = (;
        yscale = log10,
        xticklabelrotation = 0, 
        xticklabelsize = 12,
        xticksvisible = false,
        topspinecolor = :gray,
        bottomspinecolor = :gray,
        leftspinecolor = :gray,
        rightspinecolor = :gray,
        ylabel = "Time relative to C",
        xticks = (1:length(unique(bms)), bms.pool.levels),
        xminorticks = IntervalsBetween(2),
        xgridvisible = false,
        xminorgridvisible = true,
        xminorgridcolor = (:black, 0.2),
        yminorticks = IntervalsBetween(5),
        yminorgridvisible = true,
    ),
    figure = (; size = (1000, 618),)
)
leg = Legend(f[1, 2],
    [MarkerElement(; color = p.colormap[][i], marker = :circle, markersize = 11) for i in 1:length(langs.pool.levels)],
    langs.pool.levels,
    "Benchmark";
)
f
```

## Custom markers
```@example julia-benchmark
# Get logos for programming languages

using Rsvg
using CairoMakie
using CairoMakie.Cairo, CairoMakie.FileIO
using MakieTeX

language_logo_url(lang::String) = "https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/$(lowercase(lang))/$(lowercase(lang))-original.svg"

language_marker_dict = Dict{String, Any}(
    [key => read(download(language_logo_url(key)), String) |> MakieTeX.CachedSVG for key in ("c", "fortran", "go", "java", "javascript", "julia", "matlab", "python", "r", "rust")]
)

language_marker_dict["octave"] = FileIO.load(File{format"PNG"}(download("https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Gnu-octave-logo.svg/2048px-Gnu-octave-logo.svg.png"))) .|> Makie.Colors.ARGB32  

language_marker_dict["luajit"] = read(download(language_logo_url("lua")), String) |> MakieTeX.CachedSVG
language_marker_dict["mathematica"] = read(download("https://upload.wikimedia.org/wikipedia/commons/2/20/Mathematica_Logo.svg"), String) |> MakieTeX.CachedSVG


f, a, p = beeswarm(
    bms.refs, benchmarks.normtime;
    marker = getindex.((language_marker_dict,),lowercase.(benchmarks.language)),
    markersize = 11,
    axis = (;
        yscale = log10,
        xticklabelrotation = 0, 
        xticklabelsize = 12,
        xticksvisible = false,
        topspinecolor = :gray,
        bottomspinecolor = :gray,
        leftspinecolor = :gray,
        rightspinecolor = :gray,
        ylabel = "Time relative to C",
        xticks = (1:length(unique(bms)), bms.pool.levels),
        xminorticks = IntervalsBetween(2),
        xgridvisible = false,
        xminorgridvisible = true,
        xminorgridcolor = (:black, 0.2),
        yminorticks = IntervalsBetween(5),
        yminorgridvisible = true,
    ),
    figure = (; size = (1000, 618),)
)
leg = Legend(f[1, 2],
    [MarkerElement(; marker = language_marker_dict[lowercase(lang)], markersize = 15) for lang in langs.pool.levels],
    langs.pool.levels,
    "Language";
)
f
```