import{_ as s,c as n,a5 as e,o as p}from"./chunks/framework.BlUcFYL6.js";const h=JSON.parse('{"title":"Nonlinear beeswarm plots","description":"","frontmatter":{},"headers":[],"relativePath":"examples/scales.md","filePath":"examples/scales.md","lastUpdated":null}'),i={name:"examples/scales.md"};function l(t,a,o,r,c,d){return p(),n("div",null,a[0]||(a[0]=[e(`<h1 id="Nonlinear-beeswarm-plots" tabindex="-1">Nonlinear beeswarm plots <a class="header-anchor" href="#Nonlinear-beeswarm-plots" aria-label="Permalink to &quot;Nonlinear beeswarm plots {#Nonlinear-beeswarm-plots}&quot;">​</a></h1><p>Beeswarm plots can be plotted in any combination of <code>xscale</code> and <code>yscale</code>.</p><p>Specifically, beeswarm plots are correct in any <a href="https://geo.makie.org/stable/nonlinear_transforms/#Nonlinear-but-separable" target="_blank" rel="noreferrer">separable transform</a> - basically, any transform in which the x and y coordinates are independent of each other. This excludes most geographic transformations, but includes any transformation you can make using <code>xscale</code> and <code>yscale</code> in a Makie <code>Axis</code>.</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>import CairoMakie # hide</span></span>
<span class="line"><span>CairoMakie.activate!() # hide</span></span>
<span class="line"><span>import Main.MakieDocsHelpers4 # hide</span></span>
<span class="line"><span>var&quot;#result&quot; = begin # hide</span></span>
<span class="line"><span>using SwarmMakie, CairoMakie</span></span>
<span class="line"><span>data = randn(75) .+ 3</span></span>
<span class="line"><span>fig = Figure()</span></span>
<span class="line"><span>ax1 = Axis(fig[1, 1]; title = &quot;No transform&quot;)</span></span>
<span class="line"><span>beeswarm!(ax1, ones(75), data)</span></span>
<span class="line"><span>ax2 = Axis(fig[1, 2]; title = &quot;Log y axis&quot;, yscale = log10)</span></span>
<span class="line"><span>beeswarm!(ax2, ones(75), data)</span></span>
<span class="line"><span>fig</span></span>
<span class="line"><span>end # hide</span></span>
<span class="line"><span>if var&quot;#result&quot; isa Makie.FigureLike # hide</span></span>
<span class="line"><span>    MakieDocsHelpers4.AsMIME(MIME&quot;image/png&quot;(), var&quot;#result&quot;) # hide</span></span>
<span class="line"><span>else # hide</span></span>
<span class="line"><span>    var&quot;#result&quot; # hide</span></span>
<span class="line"><span>end # hide</span></span></code></pre></div><p>Note how the shape of the beeswarm is transformed in the left plot, because of the log scale.</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>import CairoMakie # hide</span></span>
<span class="line"><span>CairoMakie.activate!() # hide</span></span>
<span class="line"><span>import Main.MakieDocsHelpers4 # hide</span></span>
<span class="line"><span>var&quot;#result&quot; = begin # hide</span></span>
<span class="line"><span>ax2.xscale = Makie.pseudolog10</span></span>
<span class="line"><span>ax2.title = &quot;Log x and y axes&quot;</span></span>
<span class="line"><span>fig</span></span>
<span class="line"><span>end # hide</span></span>
<span class="line"><span>if var&quot;#result&quot; isa Makie.FigureLike # hide</span></span>
<span class="line"><span>    MakieDocsHelpers4.AsMIME(MIME&quot;image/png&quot;(), var&quot;#result&quot;) # hide</span></span>
<span class="line"><span>else # hide</span></span>
<span class="line"><span>    var&quot;#result&quot; # hide</span></span>
<span class="line"><span>end # hide</span></span></code></pre></div>`,6)]))}const m=s(i,[["render",l]]);export{h as __pageData,m as default};
