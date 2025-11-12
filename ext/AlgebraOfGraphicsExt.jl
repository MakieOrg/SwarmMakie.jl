module AlgebraOfGraphicsExt
using SwarmMakie, AlgebraOfGraphics, Makie
import AlgebraOfGraphics as AOG

# Define the "aesthetic mapping" - which kwargs go where
function AlgebraOfGraphics.aesthetic_mapping(::Type{Beeswarm}, ::AOG.Normal, ::AOG.Normal)
    AOG.dictionary([
        1 => :direction => AOG.dictionary([
            :y => AOG.AesX,
            :x => AOG.AesY,
        ]),
        2 => :direction => AOG.dictionary([
            :y => AOG.AesY,
            :x => AOG.AesX,
        ]),
        :color => AOG.AesColor,
        :strokecolor => AOG.AesColor,
        :marker => AOG.AesMarker,
        :markersize => AOG.AesMarkerSize,
        :dodge => :direction => AOG.dictionary([
            :y => AOG.AesDodgeX,
            :x => AOG.AesDodgeY,
        ])

    ])
end

# Define the legend elements (scatter, in this case)
function AOG.legend_elements(T::Type{Beeswarm}, attributes, scale_args::AOG.MixedArguments)
    return AOG.legend_elements(Makie.Scatter, attributes, scale_args) # same legend as Scatter
end

# Instruct AoG to always merge all beeswarm plots in the same layer 
# This means that if a `color` with 2 unique values is given, 
# then only one beeswarm plot object is created (not two).
AOG.mergeable(::Type{<: Beeswarm}, primary) = true

function AOG.mandatory_attributes(::Type{Beeswarm})
    AOG.dictionary([:direction => :y])
end

end
