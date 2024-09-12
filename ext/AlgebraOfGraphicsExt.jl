module AlgebraOfGraphicsExt
using SwarmMakie, AlgebraOfGraphics
import AlgebraOfGraphics: Normal, dictionary, AesColor, AesX, AesY

function AlgebraOfGraphics.aesthetic_mapping(::Type{Beeswarm}, ::Normal, ::Normal)
    dictionary([
        1 => AesX,
        2 => AesY,
        :color => AesColor,
    ])
end

end