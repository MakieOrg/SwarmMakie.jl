import{_ as s,c as a,a5 as e,o as t}from"./chunks/framework.CuDKILW4.js";const c=JSON.parse('{"title":"What is SwarmMakie.jl?","description":"","frontmatter":{"layout":"home","hero":{"name":"SwarmMakie.jl","text":null,"tagline":"Beeswarm plots for Makie.jl","image":{"src":"/logo.png","alt":"SwarmMakie"},"actions":[{"theme":"brand","text":"Introduction","link":"/introduction"},{"theme":"alt","text":"View on Github","link":"https://github.com/MakieOrg/SwarmMakie.jl"},{"theme":"alt","text":"API Reference","link":"/api"}]},"features":[{"icon":"<img width=\\"64\\" height=\\"64\\" src=\\"https://rawcdn.githack.com/JuliaLang/julia-logo-graphics/f3a09eb033b653970c5b8412e7755e3c7d78db9e/images/juliadots.iconset/icon_512x512.png\\" alt=\\"Julia code\\"/>","title":"Pure Julia code","details":"Fast, understandable, extensible functions","link":"/introduction"},{"icon":"<img width=\\"64\\" height=\\"64\\" src=\\"https://fredrikekre.github.io/Literate.jl/v2/assets/logo.png\\" />","title":"Literate programming","details":"Documented source code with examples!","link":"/source/methods/clipping/cut"},{"icon":"<img width=\\"64\\" height=\\"64\\" src=\\"https://rawcdn.githack.com/JuliaGeo/juliageo.github.io/4788480c2a5f7ae36df67a4b142e3a963024ac91/img/juliageo.svg\\" />","title":"Full integration with Makie","details":"Use any Makie.jl scatter input!","link":"https://docs.makie.org/stable/"}]},"headers":[],"relativePath":"index.md","filePath":"index.md","lastUpdated":null}'),n={name:"index.md"};function l(h,i,k,p,r,d){return t(),a("div",null,i[0]||(i[0]=[e(`<p style="margin-bottom:2cm;"></p><div class="vp-doc" style="width:80%;margin:auto;"><h1 id="what-is-swarmmakie-jl" tabindex="-1">What is SwarmMakie.jl? <a class="header-anchor" href="#what-is-swarmmakie-jl" aria-label="Permalink to &quot;What is SwarmMakie.jl?&quot;">​</a></h1><p>SwarmMakie makes beeswarm plots for Makie through the <code>beeswarm</code> recipe.</p><h2 id="quick-start" tabindex="-1">Quick start <a class="header-anchor" href="#quick-start" aria-label="Permalink to &quot;Quick start&quot;">​</a></h2><p>The entry point to this package is the <code>beeswarm</code> recipe, which accepts input the same way <code>scatter</code> does in all respects -- plus a keyword <code>algorithm</code>, which specifies the beeswarm algorithm!</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> SwarmMakie, CairoMakie</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">ys </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> rand</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">150</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">beeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ones</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">length</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ys)), ys)</span></span></code></pre></div><img src="https://github.com/MakieOrg/SwarmMakie.jl/assets/32143268/5b422b52-0017-4bd2-8c61-22ad195266b1" width="600" alt="Single, simple beeswarm"><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> SwarmMakie, CairoMakie</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">xs </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> rand</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">1</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">500</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">ys </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> randn</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">500</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">beeswarm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(xs, ys; color </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> xs)</span></span></code></pre></div><img src="https://github.com/MakieOrg/SwarmMakie.jl/assets/32143268/861f36f9-d431-41a3-8823-6d96edac0017" width="600" alt="Beeswarm with multiple categories"></div>`,2)]))}const g=s(n,[["render",l]]);export{c as __pageData,g as default};
