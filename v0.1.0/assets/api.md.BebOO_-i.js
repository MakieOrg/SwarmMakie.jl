import{_ as e,c as i,a5 as s,o as r}from"./chunks/framework.BbGH2xv9.js";const k=JSON.parse('{"title":"API Reference","description":"","frontmatter":{},"headers":[],"relativePath":"api.md","filePath":"api.md","lastUpdated":null}'),t={name:"api.md"};function n(l,a,o,p,d,c){return r(),i("div",null,a[0]||(a[0]=[s(`<h1 id="API-Reference" tabindex="-1">API Reference <a class="header-anchor" href="#API-Reference" aria-label="Permalink to &quot;API Reference {#API-Reference}&quot;">​</a></h1><ul><li><a href="#SwarmMakie.JitterAlgorithm"><code>SwarmMakie.JitterAlgorithm</code></a></li><li><a href="#SwarmMakie.NoBeeswarm"><code>SwarmMakie.NoBeeswarm</code></a></li><li><a href="#SwarmMakie.PseudorandomJitter"><code>SwarmMakie.PseudorandomJitter</code></a></li><li><a href="#SwarmMakie.QuasirandomJitter"><code>SwarmMakie.QuasirandomJitter</code></a></li><li><a href="#SwarmMakie.SeabornBeeswarm"><code>SwarmMakie.SeabornBeeswarm</code></a></li><li><a href="#SwarmMakie.SimpleBeeswarm"><code>SwarmMakie.SimpleBeeswarm</code></a></li><li><a href="#SwarmMakie.UniformJitter"><code>SwarmMakie.UniformJitter</code></a></li><li><a href="#SwarmMakie.WilkinsonBeeswarm"><code>SwarmMakie.WilkinsonBeeswarm</code></a></li><li><a href="#SwarmMakie.beeswarm-Tuple"><code>SwarmMakie.beeswarm</code></a></li><li><a href="#SwarmMakie.could_overlap-Tuple{Point2, Any, AbstractVector{&lt;:Point2}, AbstractVector}"><code>SwarmMakie.could_overlap</code></a></li><li><a href="#SwarmMakie.first_non_overlapping_candidate-NTuple{8, Any}"><code>SwarmMakie.first_non_overlapping_candidate</code></a></li><li><a href="#SwarmMakie.position_candidates-NTuple{6, Any}"><code>SwarmMakie.position_candidates</code></a></li></ul><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.JitterAlgorithm" href="#SwarmMakie.JitterAlgorithm">#</a> <b><u>SwarmMakie.JitterAlgorithm</u></b> — <i>Type</i>. <p>The abstract type for jitter algorithms, which are markersize-agnostic.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/jitter.jl#L27" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.NoBeeswarm" href="#SwarmMakie.NoBeeswarm">#</a> <b><u>SwarmMakie.NoBeeswarm</u></b> — <i>Type</i>. <p>A simple no-op algorithm, which causes the scatter plot to be drawn as if you called <code>scatter</code> and not <code>beeswarm</code>.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/recipe.jl#L53" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.PseudorandomJitter" href="#SwarmMakie.PseudorandomJitter">#</a> <b><u>SwarmMakie.PseudorandomJitter</u></b> — <i>Type</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">PseudorandomJitter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(; jitter_width </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1.0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>A jitter algorithm that uses a pseudorandom distribution to create the jitter. A pseudorandom distribution is a uniform distribution weighted by the PDF of the data.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/jitter.jl#L39-L44" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.QuasirandomJitter" href="#SwarmMakie.QuasirandomJitter">#</a> <b><u>SwarmMakie.QuasirandomJitter</u></b> — <i>Type</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">QuasirandomJitter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(; jitter_width </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1.0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>A jitter algorithm that uses a quasirandom (van der Corput) distribution weighted by the data&#39;s pdf to jitter the data points.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/jitter.jl#L49-L54" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.SeabornBeeswarm" href="#SwarmMakie.SeabornBeeswarm">#</a> <b><u>SwarmMakie.SeabornBeeswarm</u></b> — <i>Type</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">SeabornBeeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>A beeswarm algorithm based on the <code>seaborn</code> Python package.</p><p>More adaptive to marker size than <code>SimpleBeeswarm</code>, but takes longer to compute.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/seaborn.jl#L25-L32" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.SimpleBeeswarm" href="#SwarmMakie.SimpleBeeswarm">#</a> <b><u>SwarmMakie.SimpleBeeswarm</u></b> — <i>Type</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">SimpleBeeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>A simple implementation like Matplotlib&#39;s algorithm. This is the default algorithm used in <code>beeswarm</code>.</p><p>This algorithm dodges in <code>x</code> but preserves the exact <code>y</code> coordinate of each point. If you don&#39;t want to preserve the y coordinate, check out <a href="/SwarmMakie.jl/v0.1.0/api#SwarmMakie.WilkinsonBeeswarm"><code>WilkinsonBeeswarm</code></a>.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/simple.jl#L9-L17" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.UniformJitter" href="#SwarmMakie.UniformJitter">#</a> <b><u>SwarmMakie.UniformJitter</u></b> — <i>Type</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">UniformJitter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(; jitter_width </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1.0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>A jitter algorithm that uses a uniform distribution to create the jitter.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/jitter.jl#L30-L34" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.WilkinsonBeeswarm" href="#SwarmMakie.WilkinsonBeeswarm">#</a> <b><u>SwarmMakie.WilkinsonBeeswarm</u></b> — <i>Type</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">WilkinsonBeeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>A beeswarm algorithm that implements Leland Wilkinson&#39;s original dot-hist algorithm.</p><p>This is essentially a histogram with dots, where all dots are binned in the <code>y</code> (non-categorical) direction, and then dodged in the <code>x</code> (categorical) direction.</p><p>Original y-coordinates are not preserved, and if you want that try <a href="/SwarmMakie.jl/v0.1.0/api#SwarmMakie.SimpleBeeswarm"><code>SimpleBeeswarm</code></a> instead.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/wilkinson.jl#L18-L27" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.beeswarm-Tuple" href="#SwarmMakie.beeswarm-Tuple">#</a> <b><u>SwarmMakie.beeswarm</u></b> — <i>Method</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">beeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(x, y)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">beeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(positions)</span></span></code></pre></div><p><code>beeswarm</code> is a <code>PointBased</code> recipe like <code>scatter</code>, accepting all of <code>scatter</code>&#39;s input.</p><p>It displaces points which would otherwise overlap in the x-direction by binning in the y direction.</p><p>Specific attributes to <code>beeswarm</code> are:</p><ul><li><p><code>algorithm = SimpleBeeswarm()</code>: The algorithm used to lay out the beeswarm markers.</p></li><li><p><code>side = :both</code>: The side towards which markers should extend. Can be <code>:left</code>, <code>:right</code>, or both.</p></li><li><p><code>direction = :y</code>: Controls the direction of the beeswarm. Can be <code>:y</code> (vertical) or <code>:x</code> (horizontal).</p></li><li><p><code>gutter = nothing</code>: Creates a gutter of a desired size around each category. Gutter size is always in data space.</p></li><li><p><code>gutter_threshold = .5</code>: Emit a warning of the number of points added to a gutter per category exceeds the threshold.</p></li></ul><p><strong>Arguments</strong></p><p>Available attributes and their defaults for <code>Plot{SwarmMakie.beeswarm}</code> are:</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>  algorithm         SimpleBeeswarm()</span></span>
<span class="line"><span>  alpha             1.0</span></span>
<span class="line"><span>  clip_planes       MakieCore.Automatic()</span></span>
<span class="line"><span>  color             :black</span></span>
<span class="line"><span>  colormap          :viridis</span></span>
<span class="line"><span>  colorrange        MakieCore.Automatic()</span></span>
<span class="line"><span>  colorscale        identity</span></span>
<span class="line"><span>  cycle             [:color]</span></span>
<span class="line"><span>  depth_shift       0.0f0</span></span>
<span class="line"><span>  depthsorting      false</span></span>
<span class="line"><span>  direction         :y</span></span>
<span class="line"><span>  distancefield     &quot;nothing&quot;</span></span>
<span class="line"><span>  glowcolor         (:black, 0.0)</span></span>
<span class="line"><span>  glowwidth         0.0</span></span>
<span class="line"><span>  gutter            &quot;nothing&quot;</span></span>
<span class="line"><span>  gutter_threshold  0.5</span></span>
<span class="line"><span>  highclip          MakieCore.Automatic()</span></span>
<span class="line"><span>  inspectable       true</span></span>
<span class="line"><span>  inspector_clear   MakieCore.Automatic()</span></span>
<span class="line"><span>  inspector_hover   MakieCore.Automatic()</span></span>
<span class="line"><span>  inspector_label   MakieCore.Automatic()</span></span>
<span class="line"><span>  lowclip           MakieCore.Automatic()</span></span>
<span class="line"><span>  marker            :circle</span></span>
<span class="line"><span>  marker_offset     MakieCore.Automatic()</span></span>
<span class="line"><span>  markersize        9</span></span>
<span class="line"><span>  markerspace       :pixel</span></span>
<span class="line"><span>  nan_color         :transparent</span></span>
<span class="line"><span>  overdraw          false</span></span>
<span class="line"><span>  rotation          Billboard{Float32}(0.0f0)</span></span>
<span class="line"><span>  side              :both</span></span>
<span class="line"><span>  space             :data</span></span>
<span class="line"><span>  ssao              false</span></span>
<span class="line"><span>  strokecolor       :black</span></span>
<span class="line"><span>  strokewidth       0</span></span>
<span class="line"><span>  transform_marker  false</span></span>
<span class="line"><span>  transparency      false</span></span>
<span class="line"><span>  uv_offset_width   (0.0, 0.0, 0.0, 0.0)</span></span>
<span class="line"><span>  visible           true</span></span></code></pre></div><p><strong>Example</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Makie, SwarmMakie</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">beeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ones</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">100</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">), </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">randn</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">100</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); color </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> rand</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(RGBf, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">100</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">))</span></span></code></pre></div><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/recipe.jl#L9-L33" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.could_overlap-Tuple{Point2, Any, AbstractVector{&lt;:Point2}, AbstractVector}" href="#SwarmMakie.could_overlap-Tuple{Point2, Any, AbstractVector{&lt;:Point2}, AbstractVector}">#</a> <b><u>SwarmMakie.could_overlap</u></b> — <i>Method</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">could_overlap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(position, markersize, positions, markersizes)</span></span></code></pre></div><p>Check if a point given by <code>position</code> with markersize <code>markersize</code> could overlap with any other point in the swarm. Returns a vector of integer indices.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/seaborn.jl#L78-L83" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.first_non_overlapping_candidate-NTuple{8, Any}" href="#SwarmMakie.first_non_overlapping_candidate-NTuple{8, Any}">#</a> <b><u>SwarmMakie.first_non_overlapping_candidate</u></b> — <i>Method</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Returns </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">\`(position::Point2f, idx::Int)\`</span></span></code></pre></div><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/seaborn.jl#L124-L126" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SwarmMakie.position_candidates-NTuple{6, Any}" href="#SwarmMakie.position_candidates-NTuple{6, Any}">#</a> <b><u>SwarmMakie.position_candidates</u></b> — <i>Method</i>. <p>Returns <code>(positions::Vector{Point2f}, idxs::Vector{Int})</code>.</p><p><a href="https://github.com/MakieOrg/SwarmMakie.jl/blob/9a557da14f5382fb9c4424f4e9c4a7f1205d8540/src/algorithms/seaborn.jl#L94-L96" target="_blank" rel="noreferrer">source</a></p></div><br>`,26)]))}const m=e(t,[["render",n]]);export{k as __pageData,m as default};
