import{_ as a,c as n,o as s,a7 as p}from"./chunks/framework.aHyz5wEJ.js";const q=JSON.parse('{"title":"Unconventional swarm plots","description":"","frontmatter":{},"headers":[],"relativePath":"unconventional.md","filePath":"unconventional.md","lastUpdated":null}'),e={name:"unconventional.md"},l=p(`<h1 id="Unconventional-swarm-plots" tabindex="-1">Unconventional swarm plots <a class="header-anchor" href="#Unconventional-swarm-plots" aria-label="Permalink to &quot;Unconventional swarm plots {#Unconventional-swarm-plots}&quot;">​</a></h1><p>You can use swarm plots to simply separate scatter markers which share the same <code>x</code> coordinate, and distinguish them by color and marker type.</p><h2 id="The-Julia-benchmark-plot" tabindex="-1">The Julia benchmark plot <a class="header-anchor" href="#The-Julia-benchmark-plot" aria-label="Permalink to &quot;The Julia benchmark plot {#The-Julia-benchmark-plot}&quot;">​</a></h2><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span># Load the required Julia packages</span></span>
<span class="line"><span>using Base.MathConstants</span></span>
<span class="line"><span>using CSV</span></span>
<span class="line"><span>using DataFrames</span></span>
<span class="line"><span>using AlgebraOfGraphics, SwarmMakie, CairoMakie</span></span>
<span class="line"><span>using StatsBase</span></span>
<span class="line"><span></span></span>
<span class="line"><span># Load benchmark data from file</span></span>
<span class="line"><span>benchmarks =</span></span>
<span class="line"><span>    CSV.read(download(&quot;https://raw.githubusercontent.com/JuliaLang/Microbenchmarks/master/bin/benchmarks.csv&quot;), DataFrame; header = [&quot;language&quot;, &quot;benchmark&quot;, &quot;time&quot;])</span></span>
<span class="line"><span></span></span>
<span class="line"><span># Capitalize and decorate language names from datafile</span></span>
<span class="line"><span>dict = Dict(</span></span>
<span class="line"><span>    &quot;c&quot; =&gt; &quot;C&quot;,</span></span>
<span class="line"><span>    &quot;julia&quot; =&gt; &quot;Julia&quot;,</span></span>
<span class="line"><span>    &quot;lua&quot; =&gt; &quot;LuaJIT&quot;,</span></span>
<span class="line"><span>    &quot;fortran&quot; =&gt; &quot;Fortran&quot;,</span></span>
<span class="line"><span>    &quot;java&quot; =&gt; &quot;Java&quot;,</span></span>
<span class="line"><span>    &quot;javascript&quot; =&gt; &quot;JavaScript&quot;,</span></span>
<span class="line"><span>    &quot;matlab&quot; =&gt; &quot;Matlab&quot;,</span></span>
<span class="line"><span>    &quot;mathematica&quot; =&gt; &quot;Mathematica&quot;,</span></span>
<span class="line"><span>    &quot;python&quot; =&gt; &quot;Python&quot;,</span></span>
<span class="line"><span>    &quot;octave&quot; =&gt; &quot;Octave&quot;,</span></span>
<span class="line"><span>    &quot;r&quot; =&gt; &quot;R&quot;,</span></span>
<span class="line"><span>    &quot;rust&quot; =&gt; &quot;Rust&quot;,</span></span>
<span class="line"><span>    &quot;go&quot; =&gt; &quot;Go&quot;,</span></span>
<span class="line"><span>);</span></span>
<span class="line"><span>benchmarks[!, :language] = [dict[lang] for lang in benchmarks[!, :language]]</span></span>
<span class="line"><span></span></span>
<span class="line"><span># Normalize benchmark times by C times</span></span>
<span class="line"><span>ctime = benchmarks[benchmarks[!, :language] .== &quot;C&quot;, :]</span></span>
<span class="line"><span>benchmarks = innerjoin(benchmarks, ctime, on = :benchmark, makeunique = true)</span></span>
<span class="line"><span>select!(benchmarks, Not(:language_1))</span></span>
<span class="line"><span>rename!(benchmarks, :time_1 =&gt; :ctime)</span></span>
<span class="line"><span>benchmarks[!, :normtime] = benchmarks[!, :time] ./ benchmarks[!, :ctime];</span></span>
<span class="line"><span></span></span>
<span class="line"><span># Compute the geometric mean for each language</span></span>
<span class="line"><span>langs = [];</span></span>
<span class="line"><span>means = [];</span></span>
<span class="line"><span>priorities = [];</span></span>
<span class="line"><span>for lang in benchmarks[!, :language]</span></span>
<span class="line"><span>    data = benchmarks[benchmarks[!, :language] .== lang, :]</span></span>
<span class="line"><span>    gmean = geomean(data[!, :normtime])</span></span>
<span class="line"><span>    push!(langs, lang)</span></span>
<span class="line"><span>    push!(means, gmean)</span></span>
<span class="line"><span>    if (lang == &quot;C&quot;)</span></span>
<span class="line"><span>        push!(priorities, 1)</span></span>
<span class="line"><span>    elseif (lang == &quot;Julia&quot;)</span></span>
<span class="line"><span>        push!(priorities, 2)</span></span>
<span class="line"><span>    else</span></span>
<span class="line"><span>        push!(priorities, 3)</span></span>
<span class="line"><span>    end</span></span>
<span class="line"><span>end</span></span>
<span class="line"><span></span></span>
<span class="line"><span># Add the geometric means back into the benchmarks dataframe</span></span>
<span class="line"><span>langmean = Dict(langs .=&gt; tuple.(means, priorities))</span></span>
<span class="line"><span>benchmarks.geomean = first.(getindex.((langmean,), benchmarks.language))</span></span>
<span class="line"><span>benchmarks.priority = last.(getindex.((langmean,), benchmarks.language))</span></span>
<span class="line"><span></span></span>
<span class="line"><span># Put C first, Julia second, and sort the rest by geometric mean</span></span>
<span class="line"><span>sort!(benchmarks, [:priority, :geomean]);</span></span>
<span class="line"><span>sort!(langmean, [:priority, :geomean]);</span></span>
<span class="line"><span></span></span>
<span class="line"><span>langs = CategoricalArray(benchmarks.language)</span></span>
<span class="line"><span>bms = CategoricalArray(benchmarks.benchmark)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>f, a, p = beeswarm(</span></span>
<span class="line"><span>    langs.refs, benchmarks.normtime;</span></span>
<span class="line"><span>    color = bms.refs,</span></span>
<span class="line"><span>    colormap = :Set1_8,</span></span>
<span class="line"><span>    # markersize = 5,</span></span>
<span class="line"><span>    marker = Circle,</span></span>
<span class="line"><span>    axis = (;</span></span>
<span class="line"><span>        yscale = log10,</span></span>
<span class="line"><span>        xticklabelrotation = pi/4, ylabel = &quot;Time relative to C&quot;,</span></span>
<span class="line"><span>        xticks = (1:length(unique(langs)), langs.pool.levels),</span></span>
<span class="line"><span>        xminorticks = IntervalsBetween(2),</span></span>
<span class="line"><span>        xgridvisible = false,</span></span>
<span class="line"><span>        xminorgridvisible = true,</span></span>
<span class="line"><span>    ),</span></span>
<span class="line"><span>    figure = (; size = (1000, 618),)</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>leg = Legend(f[1, 2],</span></span>
<span class="line"><span>    [MarkerElement(; color = Makie.categorical_colors(:Set1_8, 8)[i], marker = :circle, markersize = 11) for i in 1:length(bms.pool.levels)],</span></span>
<span class="line"><span>    bms.pool.levels,</span></span>
<span class="line"><span>    &quot;Benchmark&quot;;</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>f</span></span></code></pre></div>`,4),t=[l];function i(o,c,r,u,m,g){return s(),n("div",null,t)}const b=a(e,[["render",i]]);export{q as __pageData,b as default};
