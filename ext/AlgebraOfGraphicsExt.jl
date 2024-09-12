module AlgebraOfGraphicsExt
using SwarmMakie, AlgebraOfGraphics, Makie
import AlgebraOfGraphics as AOG

function AlgebraOfGraphics.aesthetic_mapping(::Type{Beeswarm}, ::AOG.Normal, ::AOG.Normal)
    AOG.dictionary([
        1 => AOG.AesX,
        2 => AOG.AesY,
        :color => AOG.AesColor,
        :marker => AOG.AesMarker,
        :markersize => AOG.AesMarkerSize,
    ])
end


function AOG.legend_elements(T::Type{Beeswarm}, attributes, scale_args::AOG.MixedArguments)
    [Makie.MarkerElement(
        color = AOG._get(T, scale_args, attributes, :color),
        markerpoints = [Point2f(0.5, 0.5)],
        marker = AOG._get(T, scale_args, attributes, :marker),
        markerstrokewidth = AOG._get(T, scale_args, attributes, :strokewidth),
        markersize = AOG._get(T, scale_args, attributes, :markersize),
        markerstrokecolor = AOG._get(T, scale_args, attributes, :strokecolor),
    )]
end

end
