module AlgebraOfGraphicsExt
using SwarmMakie, AlgebraOfGraphics, Makie
import AlgebraOfGraphics as AOG

function AlgebraOfGraphics.aesthetic_mapping(::Type{Beeswarm}, ::AOG.Normal, ::AOG.Normal)
    AOG.dictionary([
        1 => AOG.AesX,
        2 => AOG.AesY,
        :color => AOG.AesColor,
        :strokecolor => AOG.AesColor,
        :marker => AOG.AesMarker,
        :markersize => AOG.AesMarkerSize,
    ])
end


function AOG.legend_elements(T::Type{Beeswarm}, attributes, scale_args::AOG.MixedArguments)
    return AOG.legend_elements(Makie.Scatter, attributes, scale_args) # same legend as Scatter
end

end
