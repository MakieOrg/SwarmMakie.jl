# # Jitter algorithms

export UniformJitter, PseudorandomJitter, QuasirandomJitter

#=
Jitter is a way for scatterplots to receive a bit of randomness in the points,
so that overlapping points are visible.

It's not exactly a beeswarm plot, since there are no guarantees that all points are shown,
and nor is there any consideration of marker size.

Still, it's good enough for government work!

The algorithms in this file were provided by
Benedikt Ehinger and Vladimir Mikheev, in
(https://github.com/MakieOrg/Makie.jl/pull/2872)[PR 2872 to Makie.jl].
=#

"The abstract type for jitter algorithms, which are markersize-agnostic."
abstract type JitterAlgorithm <: BeeswarmAlgorithm end

output_space(::JitterAlgorithm) = :data

"""
	UniformJitter()

A jitter algorithm that uses a uniform distribution to create the jitter.
"""
Base.@kwdef struct UniformJitter <: JitterAlgorithm 
	jitter_width::Union{Makie.Automatic,Float64} = Makie.automatic
	gap::Float64 = 0.33
	seed::Union{Nothing,Int} = nothing
end
"""
	PseudorandomJitter()

A jitter algorithm that uses a pseudorandom distribution to create the jitter.
A pseudorandom distribution is a uniform distribution weighted by the PDF of the data.
"""
Base.@kwdef struct PseudorandomJitter <: JitterAlgorithm 
	jitter_width::Union{Makie.Automatic,Float64} = Makie.automatic
	gap::Float64 = 0.33
	seed::Union{Nothing,Int} = nothing
end
"""
	QuasirandomJitter()

A jitter algorithm that uses a quasirandom (van der Corput) distribution
weighted by the data's pdf to jitter the data points.
"""
Base.@kwdef struct QuasirandomJitter <: JitterAlgorithm 
	jitter_width::Union{Makie.Automatic,Float64} = Makie.automatic
	gap::Float64 = 0.33
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::JitterAlgorithm, positions::AbstractVector{<: Point2}, markersize, side::Symbol)
	xs = first.(positions)
	ys = last.(positions)

	width::Float64 = if alg.jitter_width === Makie.automatic
		uxs = unique(xs)
		diffs = diff(sort(uxs))
		isempty(diffs) ? one(eltype(diffs)) : minimum(diffs)
	else
		alg.jitter_width
	end

	width_without_gap = width * (1 - alg.gap)

	for x_val in unique(xs)
		# Isolate the indices of this particular group
		group = xs .== x_val
		# Extract the marker size
	        ms = if markersize isa Number
	            markersize
	        else
	            view(markersize, group)
	        end
		# Assign the jittered values to the buffer
		@views buffer[group] .= Point2f.(xs[group] .+ width_without_gap .* create_jitter_array(ys[group], alg), ys[group])
	end
end

jitter_uniform(n::Int, seed::Int) = jitter_uniform(StableRNGs.StableRNG(seed), n)
jitter_uniform(n::Int, ::Nothing) = jitter_uniform(Random.GLOBAL_RNG, n)
jitter_uniform(RNG::Random.AbstractRNG, n) = rand(RNG,n)

jitter_vandercorput(num) = sum(d * 2. ^-ex for (ex, d) in enumerate(digits(num, base = 2)))

function create_jitter_array(data_array, jitter_type = UniformJitter())
	if jitter_type isa UniformJitter
		jitter = jitter_uniform(length(data_array), jitter_type.seed)
	elseif jitter_type isa PseudorandomJitter
		jitter = jitter_uniform(length(data_array), jitter_type.seed)
	elseif jitter_type isa QuasirandomJitter
		jitter = jitter_vandercorput.(1:length(data_array))
	else
		error("jitter_type not implemented")
	end

	# center
	jitter .-= 0.5

	# weight it
	if jitter_type isa Union{PseudorandomJitter, QuasirandomJitter}
		k = KernelDensity.kde(data_array,npoints=200)	
		ik = KernelDensity.InterpKDE(k)
		pdf_x = KernelDensity.pdf(ik, data_array)
		pdf_x = pdf_x ./ maximum(pdf_x)
		jitter = pdf_x .* jitter
	end

    return jitter
end
