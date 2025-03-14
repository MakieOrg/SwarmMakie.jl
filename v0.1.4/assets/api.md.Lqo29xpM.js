import{_ as r,C as o,c as p,o as d,aA as l,j as e,G as i,a as t,w as n}from"./chunks/framework.DQfqHo_V.js";const F=JSON.parse('{"title":"API Reference","description":"","frontmatter":{},"headers":[],"relativePath":"api.md","filePath":"api.md","lastUpdated":null}'),c={name:"api.md"},k={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},w={class:"jldocstring custom-block",open:""},S={class:"jldocstring custom-block",open:""},_={class:"jldocstring custom-block",open:""},j={class:"jldocstring custom-block",open:""},M={class:"jldocstring custom-block",open:""};function T(C,s,E,v,A,B){const a=o("Badge");return d(),p("div",null,[s[52]||(s[52]=l('<h1 id="API-Reference" tabindex="-1">API Reference <a class="header-anchor" href="#API-Reference" aria-label="Permalink to &quot;API Reference {#API-Reference}&quot;">​</a></h1><ul><li><a href="#SwarmMakie.JitterAlgorithm"><code>SwarmMakie.JitterAlgorithm</code></a></li><li><a href="#SwarmMakie.NoBeeswarm"><code>SwarmMakie.NoBeeswarm</code></a></li><li><a href="#SwarmMakie.PseudorandomJitter"><code>SwarmMakie.PseudorandomJitter</code></a></li><li><a href="#SwarmMakie.QuasirandomJitter"><code>SwarmMakie.QuasirandomJitter</code></a></li><li><a href="#SwarmMakie.SeabornBeeswarm"><code>SwarmMakie.SeabornBeeswarm</code></a></li><li><a href="#SwarmMakie.SimpleBeeswarm"><code>SwarmMakie.SimpleBeeswarm</code></a></li><li><a href="#SwarmMakie.SimpleBeeswarm2"><code>SwarmMakie.SimpleBeeswarm2</code></a></li><li><a href="#SwarmMakie.UniformJitter"><code>SwarmMakie.UniformJitter</code></a></li><li><a href="#SwarmMakie.WilkinsonBeeswarm"><code>SwarmMakie.WilkinsonBeeswarm</code></a></li><li><a href="#SwarmMakie.beeswarm-Tuple"><code>SwarmMakie.beeswarm</code></a></li><li><a href="#SwarmMakie.could_overlap-Tuple{Point2, Any, AbstractVector{&lt;:Point2}, AbstractVector}"><code>SwarmMakie.could_overlap</code></a></li><li><a href="#SwarmMakie.first_non_overlapping_candidate-NTuple{8, Any}"><code>SwarmMakie.first_non_overlapping_candidate</code></a></li><li><a href="#SwarmMakie.position_candidates-NTuple{6, Any}"><code>SwarmMakie.position_candidates</code></a></li></ul>',2)),e("details",k,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SwarmMakie.JitterAlgorithm",href:"#SwarmMakie.JitterAlgorithm"},[e("span",{class:"jlbinding"},"SwarmMakie.JitterAlgorithm")],-1)),s[1]||(s[1]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[3]||(s[3]=e("p",null,"The abstract type for jitter algorithms, which are markersize-agnostic.",-1)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[2]||(s[2]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/jitter.jl#L27",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",h,[e("summary",null,[s[4]||(s[4]=e("a",{id:"SwarmMakie.NoBeeswarm",href:"#SwarmMakie.NoBeeswarm"},[e("span",{class:"jlbinding"},"SwarmMakie.NoBeeswarm")],-1)),s[5]||(s[5]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[7]||(s[7]=e("p",null,[t("A simple no-op algorithm, which causes the scatter plot to be drawn as if you called "),e("code",null,"scatter"),t(" and not "),e("code",null,"beeswarm"),t(".")],-1)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[6]||(s[6]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/recipe.jl#L53",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",m,[e("summary",null,[s[8]||(s[8]=e("a",{id:"SwarmMakie.PseudorandomJitter",href:"#SwarmMakie.PseudorandomJitter"},[e("span",{class:"jlbinding"},"SwarmMakie.PseudorandomJitter")],-1)),s[9]||(s[9]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[11]||(s[11]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">PseudorandomJitter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(; jitter_width </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1.0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>A jitter algorithm that uses a pseudorandom distribution to create the jitter. A pseudorandom distribution is a uniform distribution weighted by the PDF of the data.</p>',2)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[10]||(s[10]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/jitter.jl#L39-L44",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",u,[e("summary",null,[s[12]||(s[12]=e("a",{id:"SwarmMakie.QuasirandomJitter",href:"#SwarmMakie.QuasirandomJitter"},[e("span",{class:"jlbinding"},"SwarmMakie.QuasirandomJitter")],-1)),s[13]||(s[13]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[15]||(s[15]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">QuasirandomJitter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(; jitter_width </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1.0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>A jitter algorithm that uses a quasirandom (van der Corput) distribution weighted by the data&#39;s pdf to jitter the data points.</p>',2)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[14]||(s[14]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/jitter.jl#L49-L54",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",g,[e("summary",null,[s[16]||(s[16]=e("a",{id:"SwarmMakie.SeabornBeeswarm",href:"#SwarmMakie.SeabornBeeswarm"},[e("span",{class:"jlbinding"},"SwarmMakie.SeabornBeeswarm")],-1)),s[17]||(s[17]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[19]||(s[19]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">SeabornBeeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>A beeswarm algorithm based on the <code>seaborn</code> Python package.</p><p>More adaptive to marker size than <code>SimpleBeeswarm</code>, but takes longer to compute.</p>',3)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[18]||(s[18]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/seaborn.jl#L25-L32",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",b,[e("summary",null,[s[20]||(s[20]=e("a",{id:"SwarmMakie.SimpleBeeswarm",href:"#SwarmMakie.SimpleBeeswarm"},[e("span",{class:"jlbinding"},"SwarmMakie.SimpleBeeswarm")],-1)),s[21]||(s[21]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[23]||(s[23]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">SimpleBeeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>A simple implementation like Matplotlib&#39;s algorithm.</p><p>This algorithm dodges in <code>x</code> but preserves the exact <code>y</code> coordinate of each point. If you don&#39;t want to preserve the y coordinate, check out <a href="/SwarmMakie.jl/v0.1.4/api#SwarmMakie.WilkinsonBeeswarm"><code>WilkinsonBeeswarm</code></a>.</p>',3)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[22]||(s[22]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/simple.jl#L9-L16",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",f,[e("summary",null,[s[24]||(s[24]=e("a",{id:"SwarmMakie.SimpleBeeswarm2",href:"#SwarmMakie.SimpleBeeswarm2"},[e("span",{class:"jlbinding"},"SwarmMakie.SimpleBeeswarm2")],-1)),s[25]||(s[25]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[27]||(s[27]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">SimpleBeeswarm2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>A simple beeswarm implementation, that minimizes overlaps. This is the default algorithm used in <code>beeswarm</code>.</p><p>This algorithm dodges in <code>x</code> but preserves the exact <code>y</code> coordinate of each point. If you don&#39;t want to preserve the y coordinate, check out <a href="/SwarmMakie.jl/v0.1.4/api#SwarmMakie.WilkinsonBeeswarm"><code>WilkinsonBeeswarm</code></a>.</p>',3)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[26]||(s[26]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/simple2.jl#L4-L12",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",y,[e("summary",null,[s[28]||(s[28]=e("a",{id:"SwarmMakie.UniformJitter",href:"#SwarmMakie.UniformJitter"},[e("span",{class:"jlbinding"},"SwarmMakie.UniformJitter")],-1)),s[29]||(s[29]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[31]||(s[31]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">UniformJitter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(; jitter_width </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1.0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>A jitter algorithm that uses a uniform distribution to create the jitter.</p>',2)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[30]||(s[30]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/jitter.jl#L30-L34",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",w,[e("summary",null,[s[32]||(s[32]=e("a",{id:"SwarmMakie.WilkinsonBeeswarm",href:"#SwarmMakie.WilkinsonBeeswarm"},[e("span",{class:"jlbinding"},"SwarmMakie.WilkinsonBeeswarm")],-1)),s[33]||(s[33]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[35]||(s[35]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">WilkinsonBeeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>A beeswarm algorithm that implements Leland Wilkinson&#39;s original dot-hist algorithm.</p><p>This is essentially a histogram with dots, where all dots are binned in the <code>y</code> (non-categorical) direction, and then dodged in the <code>x</code> (categorical) direction.</p><p>Original y-coordinates are not preserved, and if you want that try <a href="/SwarmMakie.jl/v0.1.4/api#SwarmMakie.SimpleBeeswarm"><code>SimpleBeeswarm</code></a> instead.</p>',4)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[34]||(s[34]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/wilkinson.jl#L18-L27",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",S,[e("summary",null,[s[36]||(s[36]=e("a",{id:"SwarmMakie.beeswarm-Tuple",href:"#SwarmMakie.beeswarm-Tuple"},[e("span",{class:"jlbinding"},"SwarmMakie.beeswarm")],-1)),s[37]||(s[37]=t()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[39]||(s[39]=l(`<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">beeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(x, y)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">beeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(positions)</span></span></code></pre></div><p><code>beeswarm</code> is a <code>PointBased</code> recipe like <code>scatter</code>, accepting all of <code>scatter</code>&#39;s input.</p><p>It displaces points which would otherwise overlap in the x-direction by binning in the y direction.</p><p>Specific attributes to <code>beeswarm</code> are:</p><ul><li><p><code>algorithm = SimpleBeeswarm2()</code>: The algorithm used to lay out the beeswarm markers.</p></li><li><p><code>side = :both</code>: The side towards which markers should extend. Can be <code>:left</code>, <code>:right</code>, or both.</p></li><li><p><code>direction = :y</code>: Controls the direction of the beeswarm. Can be <code>:y</code> (vertical) or <code>:x</code> (horizontal).</p></li><li><p><code>gutter = nothing</code>: Creates a gutter of a desired size around each category. Gutter size is always in data space.</p></li><li><p><code>gutter_threshold = .5</code>: Emit a warning of the number of points added to a gutter per category exceeds the threshold.</p></li></ul><p><strong>Arguments</strong></p><p>Available attributes and their defaults for <code>Plot{SwarmMakie.beeswarm}</code> are:</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>  algorithm         SimpleBeeswarm2()</span></span>
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
<span class="line"><span>  marker_offset     Float32[0.0, 0.0, 0.0]</span></span>
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
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">beeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ones</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">100</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">), </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">randn</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">100</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); color </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> rand</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(RGBf, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">100</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">))</span></span></code></pre></div>`,10)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[38]||(s[38]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/recipe.jl#L9-L33",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",_,[e("summary",null,[s[40]||(s[40]=e("a",{id:"SwarmMakie.could_overlap-Tuple{Point2, Any, AbstractVector{<:Point2}, AbstractVector}",href:"#SwarmMakie.could_overlap-Tuple{Point2, Any, AbstractVector{<:Point2}, AbstractVector}"},[e("span",{class:"jlbinding"},"SwarmMakie.could_overlap")],-1)),s[41]||(s[41]=t()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[43]||(s[43]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">could_overlap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(position, markersize, positions, markersizes)</span></span></code></pre></div><p>Check if a point given by <code>position</code> with markersize <code>markersize</code> could overlap with any other point in the swarm. Returns a vector of integer indices.</p>',2)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[42]||(s[42]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/seaborn.jl#L78-L83",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",j,[e("summary",null,[s[44]||(s[44]=e("a",{id:"SwarmMakie.first_non_overlapping_candidate-NTuple{8, Any}",href:"#SwarmMakie.first_non_overlapping_candidate-NTuple{8, Any}"},[e("span",{class:"jlbinding"},"SwarmMakie.first_non_overlapping_candidate")],-1)),s[45]||(s[45]=t()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[47]||(s[47]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Returns </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">`(position::Point2f, idx::Int)`</span></span></code></pre></div>',1)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[46]||(s[46]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/seaborn.jl#L124-L126",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",M,[e("summary",null,[s[48]||(s[48]=e("a",{id:"SwarmMakie.position_candidates-NTuple{6, Any}",href:"#SwarmMakie.position_candidates-NTuple{6, Any}"},[e("span",{class:"jlbinding"},"SwarmMakie.position_candidates")],-1)),s[49]||(s[49]=t()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[51]||(s[51]=e("p",null,[t("Returns "),e("code",null,"(positions::Vector{Point2f}, idxs::Vector{Int})"),t(".")],-1)),i(a,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[50]||(s[50]=[e("a",{href:"https://github.com/MakieOrg/SwarmMakie.jl/blob/59dc3bc888bd60dc3bfd5e50d8006fd2901ff688/src/algorithms/seaborn.jl#L94-L96",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const P=r(c,[["render",T]]);export{F as __pageData,P as default};
