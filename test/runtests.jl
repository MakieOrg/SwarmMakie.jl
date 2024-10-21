using SwarmMakie, Makie, CairoMakie
using Makie.Colors
using Test
using Random

Random.seed!(123)

colors = RGBf.(LinRange(0, 1, 1000), 0, 0)

fig, ax, plt = scatter(ones(1000), randn(1000); color = colors)
Makie.update_state_before_display!(fig)
original_points = Point2f.(plt.converted[1][])
pixel_points = Point2f.(Makie.project.((ax.scene.camera,), :data, :pixel, original_points))
buffer = deepcopy(pixel_points)

@testset "SwarmMakie.jl" begin
    @testset "Algorithms run without error" begin
        for algorithm in [NoBeeswarm(), SimpleBeeswarm(), WilkinsonBeeswarm(), UniformJitter(), PseudorandomJitter(), QuasirandomJitter()]
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
            img = Makie.colorbuffer(f.scene; px_per_unit = 1, pt_per_unit = 1, antialias = :none, visible = true, start_renderloop = false)
            # We have a matrix of all colors in the image.  Now, what we do is the following:
            # The color white in RGBf is (1, 1, 1).  For a color to be red, the blue and green components
            # must correspondingly decrease, since the RGBf values cannot exceed 1.
            # So, we know if a red pixel with alpha=0.5 is rendered, the blue value there will be between 0.6 and 0.4.
            # If more than one marker is rendered, the red is more intense and the blue value will be even less than 4.
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
            @test overlap_pixels/nonwhite_pixels < 0.07 # 7% overlap should be our ideal for this sort of data - this is totally arbitrary.
        end
    end
    @testset "Gutters" begin
        # First, we test the regular gutter with multiple categories.
        f, a, p = beeswarm(rand(1:3, 300), randn(300); color = rand(RGBAf, 300), markersize = 20, algorithm = SimpleBeeswarm())
        Makie.update_state_before_display!(f)        
        @test_warn "Gutter threshold exceeded" p.gutter = 0.2
        # Next, we test it in direction y
        f, a, p = beeswarm(rand(1:3, 300), randn(300); direction = :x, color = rand(RGBAf, 300), markersize = 20, algorithm = SimpleBeeswarm())        
        Makie.update_state_before_display!(f)
        @test_warn "Gutter threshold exceeded" p.gutter = 0.2
        # and it shouldn't warn if, when using a lower markersize, the gutter is not reached.
        f, a, p = beeswarm(rand(1:3, 300), randn(300); direction = :y, color = rand(RGBAf, 300), markersize = 9, algorithm = SimpleBeeswarm())      
        Makie.update_state_before_display!(f)
        @test_nowarn p.gutter = 0.5
    end
end

# TODO: 
# - Test that the order of points is preserved
# How to do this?  Test y values for SimpleBeeswarm and use StatsBase.histogram to test WilkinsonBeeswarm.  Jitter should just make sure y coordinates are preserved.
