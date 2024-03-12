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

#=
Allow to globally set jitter RNG for testing.

A bit of a lazy solution, but it doesn't seem to be desirable to
pass the RNG through the plotting command.
=#
const JITTER_RNG = Ref{Random.AbstractRNG}(Random.GLOBAL_RNG)

"The abstract type for jitter algorithms, which are markersize-agnostic."
abstract type JitterAlgorithm <: BeeswarmAlgorithm end

"""
	UniformJitter(; jitter_width = 1.0)

A jitter algorithm that uses a uniform distribution to create the jitter.
"""
Base.@kwdef struct UniformJitter <: JitterAlgorithm 
	jitter_width::Float32 = 1.0
	clamped_portion::Float32 = 0.0
end
"""
	PseudorandomJitter(; jitter_width = 1.0)

A jitter algorithm that uses a pseudorandom distribution to create the jitter.
A pseudorandom distribution is a uniform distribution weighted by the PDF of the data.
"""
Base.@kwdef struct PseudorandomJitter <: JitterAlgorithm 
	jitter_width::Float32 = 1.0
	clamped_portion::Float32 = 0.0
end
"""
	QuasirandomJitter(; jitter_width = 1.0)

A jitter algorithm that uses a quasirandom (van der Corput) distribution
weighted by the data's pdf to jitter the data points.
"""
Base.@kwdef struct QuasirandomJitter <: JitterAlgorithm 
	jitter_width::Float32 = 1.0
	clamped_portion::Float32 = 0.0
end

function calculate!(buffer::AbstractVector{<: Point2}, alg::JitterAlgorithm, positions::AbstractVector{<: Point2}, markersize, side::Symbol)
	xs = first.(positions)
	ys = last.(positions)
	for x_val in unique(xs)
		group = xs .== x_val
		@views buffer[group] .= Point2f.(xs[group] .+ create_jitter_array(ys[group], alg) .* markersize, ys[group])
	end
end





# quick custom function for jitter
jitter_uniform(n) = jitter_uniform(JITTER_RNG[],n)
jitter_uniform(RNG::Random.AbstractRNG, n) = rand(RNG,n)

jitter_vandercorput(num) = sum(d * 2. ^-ex for (ex, d) in enumerate(digits(num, base = 2)))
function create_jitter_array(data_array, jitter_type = UniformJitter())
	jitter_width = jitter_type.jitter_width
	clamped_portion = jitter_type.clamped_portion
    jitter_width < 0 && ArgumentError("`jitter_width` should be positive.")
    !(0 <= clamped_portion <= 1) || ArgumentError("`clamped_portion` should be between 0.0 to 1.0")

    # Make base jitter, note base jitter minimum-to-maximum span is 1.0
    base_min, base_max = (-0.5, 0.5)


	if jitter_type isa UniformJitter
		jitter = jitter_uniform(length(data_array))
	elseif jitter_type isa PseudorandomJitter
		jitter = jitter_uniform(length(data_array))
	elseif jitter_type isa QuasirandomJitter
		jitter = jitter_vandercorput.(1:length(data_array))
	else
		error("jitter_type not implemented")
	end

	jitter = jitter.*(base_max-base_min).+base_min

	# weight it
	if jitter_type isa Union{PseudorandomJitter, QuasirandomJitter}

		k = KernelDensity.kde(data_array,npoints=200)	
		ik = KernelDensity.InterpKDE(k)
		pdf_x = KernelDensity.pdf(ik, data_array)
		pdf_x = pdf_x ./ maximum(pdf_x)
		jitter = pdf_x .* jitter
	end


    # created clamp_min, and clamp_max to clamp a portion of the data
    @assert (base_max - base_min) == 1.0
    @assert (base_max + base_min) / 2.0 == 0
    clamp_min = base_min + (clamped_portion / 2.0)
    clamp_max = base_max - (clamped_portion / 2.0)

    # clamp if need be
    clamp!(jitter, clamp_min, clamp_max)

    # Based on assumptions of clamp_min and clamp_max above
    jitter = jitter * (0.5jitter_width / clamp_max)

    return jitter
end