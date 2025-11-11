using SwarmMakie, Makie, CairoMakie
using Makie.Colors
using Test
using PixelMatch
using StableRNGs


include("reftest_utils.jl")

@testset "SwarmMakie.jl" begin

    function test_data()
        rng = StableRNGs.StableRNG(123)
        x = [fill(1, 20); fill(2, 30); fill(3, 25)]
        y = [
            sort(randn(rng, 20));
            sort(randn(rng, 30)) .* 1.5 .+ 2;
            sort(randn(rng, 25)) .* 0.7 .- 2
        ]
        return x, y
    end

    reftest("default") do
        beeswarm(test_data()...)
    end

    reftest("default array color") do
        x, y = test_data()
        beeswarm(x, y, color = 1:length(x), colormap = :Spectral)
    end

    reftest("default scalar markersize 15") do
        beeswarm(test_data()..., markersize = 15)
    end

    reftest("default scalar markersize 12") do
        beeswarm(test_data()..., markersize = 12)
    end

    reftest("wilkinson") do
        beeswarm(test_data()..., algorithm = :wilkinson)
    end

    reftest("wilkinson array color") do
        # to see that order is preserved
        x, y = test_data()
        beeswarm(x, y, algorithm = :wilkinson, color = 1:length(x), colormap = :Spectral)
    end

    reftest("wilkinson markersize 15") do
        beeswarm(test_data()..., algorithm = :wilkinson, markersize = 15)
    end

    reftest("uniform jitter") do
        beeswarm(test_data()..., algorithm = :uniform, seed = 123)
    end

    reftest("uniform jitter one group") do
        _, y = test_data()
        beeswarm(ones(size(y)), y, algorithm = :uniform, seed = 123)
    end

    reftest("quasirandom jitter") do
        beeswarm(test_data()..., algorithm = :quasirandom)
    end

    reftest("pseudorandom jitter") do
        beeswarm(test_data()..., algorithm = :pseudorandom, seed = 123)
    end

end