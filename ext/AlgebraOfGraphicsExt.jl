module AlgebraOfGraphicsExt
using SwarmMakie, AlgebraOfGraphics
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

end
