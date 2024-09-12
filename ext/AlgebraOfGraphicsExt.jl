module AlgebraOfGraphicsExt
using SwarmMakie, AlgebraOfGraphics
import AlgebraOfGraphics as AOG

function AlgebraOfGraphics.aesthetic_mapping(::Type{Beeswarm}, ::AOG.Normal, ::AOG.Normal)
    AOG.dictionary([
        1 => AesX,
        2 => AesY,
        :color => AOG.AesColor,
        :marker => AOG.AesMarker,
        :markersize => AOG.AesMarkerSize,
    ])
end

end
