using SwarmMakie, Makie, CairoMakie
using Makie.Colors
using Test

colors = RGBf.(LinRange(0, 1, 1000), 0, 0)

fig, ax, plt = scatter(ones(1000), randn(1000); color = colors)
Makie.update_state_before_display!(fig)
original_points = Point2f.(plt.converted[1][])
pixel_points = Point2f.(Makie.project.((ax.scene.camera,), :data, :pixel, original_points))
buffer = deepcopy(pixel_points)

@testset "SwarmMakie.jl" begin
    @testset "Algorithms run without error" begin
        for algorithm in [NoBeeswarm(), SimpleBeeswarm(), WilkinsonBeeswarm()]
            @test_nowarn begin
                SwarmMakie.calculate!(buffer, algorithm, pixel_points, 10, :left)
            end
        end
    end
    @testset "Overlaps" begin
        for algorithm in [SimpleBeeswarm(), WilkinsonBeeswarm()]
            # We test how many points are overlapping, proportionately.
            f, a, p = beeswarm(original_points; alpha = 0.5, algorithm, color = :red)
            hidedecorations!(a)
            hidespines!(a)
            Makie.update_state_before_display!(f)
            Makie.update_state_before_display!(f)
            Makie.update_state_before_display!(f)
            img = Makie.colorbuffer(f.scene; screen_config = CairoMakie.ScreenConfig(1, 1, :none, true, false))
            nonwhite_pixels = 0
            overlap_pixels = 0
            for pixel in img
                if Colors.blue(pixel) ≤ 0.6f0  && Colors.blue(pixel) >= 0.4f0 # this is a single point rendered
                    nonwhite_pixels += 1
                elseif Colors.blue(pixel) < 0.4f0 # this is an overlap
                    nonwhite_pixels += 1
                    overlap_pixels += 1
                end
            end
            @test overlap_pixels/nonwhite_pixels < 0.07 # 7% overlap should be our ideal for this sort of data
        end
    end
end

# TODO: 
# - Test gutters when added
# - Test that the order of points is preserved