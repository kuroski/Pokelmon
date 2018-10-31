module View.Helpers exposing (pokeColor)

import Model exposing (PokeColor(..))


type alias ColorAttributes =
    { background : String
    , hover : String
    , text : String
    }


pokeColor : PokeColor -> ColorAttributes
pokeColor color =
    case color of
        Black ->
            ColorAttributes "bg-black" "hover:bg-grey-darkest" "text-white"

        Blue ->
            ColorAttributes "bg-blue" "hover:bg-blue-dark" "text-white"

        Brown ->
            ColorAttributes "bg-orange-darker" "hover:bg-orange-dark" "text-white"

        Grey ->
            ColorAttributes "bg-grey" "hover:bg-grey-dark" "text-black"

        Green ->
            ColorAttributes "bg-green" "hover:bg-green-dark" "text-white"

        Pink ->
            ColorAttributes "bg-pink" "hover:bg-pink-dark" "text-white"

        Purple ->
            ColorAttributes "bg-purple" "hover:bg-purple-dark" "text-white"

        Red ->
            ColorAttributes "bg-red" "hover:bg-red-dark" "text-white"

        White ->
            ColorAttributes "bg-white" "hover:bg-white-dark" "text-black"

        Yellow ->
            ColorAttributes "bg-yellow" "hover:bg-yellow-dark" "text-yellow-darkest"
