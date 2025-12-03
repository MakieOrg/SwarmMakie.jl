using SwarmMakie, Makie, CairoMakie
using Makie.Colors
using Test
using PixelMatch
using StableRNGs
import AlgebraOfGraphics as AoG


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

    reftest("default alpha") do
        x, y = test_data()
        beeswarm(x, y, alpha = 0.3)
    end

    reftest("default direction x") do
        x, y = test_data()
        beeswarm(x, y, direction = :x)
    end

    reftest("default scalar markersize 15") do
        beeswarm(test_data()..., markersize = 15)
    end

    reftest("default scalar markersize 12") do
        beeswarm(test_data()..., markersize = 12)
    end

    reftest("none") do
        beeswarm(test_data()...; algorithm = :none)
    end

    reftest("wilkinson") do
        beeswarm(test_data()..., algorithm = :wilkinson)
    end

    reftest("wilkinson array color") do
        # to see that order is preserved
        x, y = test_data()
        beeswarm(x, y, algorithm = :wilkinson, color = 1:length(x), colormap = :Spectral)
    end

    reftest("wilkinson sides") do
        x, y = test_data()
        f, _ = beeswarm(x, y, algorithm = :wilkinson, color = :red, side = :left)
        beeswarm!(x, y .+ 1, algorithm = :wilkinson, color = :blue, side = :right)
        f
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

    reftest("quasirandom jitter direction x") do
        beeswarm(test_data()..., algorithm = :quasirandom, direction = :x)
    end

    reftest("pseudorandom jitter") do
        beeswarm(test_data()..., algorithm = :pseudorandom, seed = 123)
    end

    function test_data_dodge()
        _x, _y = test_data()
        x = repeat(_x, 3)
        dodge = repeat(1:3, inner = length(_x))
        y = repeat(_y, 3) .+ dodge
        return x, y, dodge
    end

    for alg in [:quasirandom, :wilkinson, :default]
        reftest("$alg dodge") do
            x, y, dodge = test_data_dodge()
            f, _ = beeswarm(
                x,
                y;
                dodge,
                algorithm = alg,
                seed = 123,
                gap = 0.2,
                color = dodge
            )
            barplot!(
                [1, 1, 1, 2, 2, 2, 3, 3, 3],
                [1, 2, 3, 2, 3, 4, 3, 4, 5],
                dodge = [1, 2, 3, 1, 2, 3, 1, 2, 3],
                alpha = 0.2,
                color = [1, 2, 3, 1, 2, 3, 1, 2, 3],
            )
            f
        end

        reftest("$alg dodge single-group") do
            rng = StableRNGs.StableRNG(123)
            x = ones(Int, 120)
            y = [randn(rng, 40); randn(rng, 40) .+ 2; randn(rng, 40) .- 2]
            beeswarm(x, y, dodge = repeat(1:3, inner = 40), algorithm = alg)
        end
    end

    reftest("AoG basic") do
        x, y = test_data()
        spec = AoG.mapping(x, y, color = x => AoG.nonnumeric) * AoG.visual(Beeswarm)
        AoG.draw(spec)
    end

    reftest("AoG direction x") do
        x, y = test_data()
        spec = AoG.mapping(x, y, color = x => AoG.nonnumeric) *
            AoG.visual(Beeswarm, algorithm = :quasirandom, direction = :x)
        AoG.draw(spec)
    end

    reftest("AoG dodge") do
        x, y, dodge = test_data_dodge()
        spec = AoG.mapping(x, y, color = x, dodge = dodge => AoG.nonnumeric) *
            AoG.visual(Beeswarm, algorithm = :quasirandom)
        AoG.draw(spec)
    end
end