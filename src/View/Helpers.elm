module View.Helpers exposing (pokeColorAttributes, ColorAttributes)

import Model exposing (PokeColor(..))


type alias ColorAttributes =
    { background : String
    , hover : String
    , text : String
    , color : String
    , border : String
    , focusBorder : String
    }


pokeColorAttributes : PokeColor -> ColorAttributes
pokeColorAttributes color =
    case color of
        Black ->
            ColorAttributes "bg-black" "hover:bg-grey-darkest" "text-white" "text-black" "border-black" "focus:border-black"

        Blue ->
            ColorAttributes "bg-blue" "hover:bg-blue-dark" "text-white" "text-blue" "border-blue" "focus:border-blue"

        Brown ->
            ColorAttributes "bg-orange-darker" "hover:bg-orange-dark" "text-white" "text-orange-darker" "border-orange-darker" "focus:border-orange-darker"

        Grey ->
            ColorAttributes "bg-grey" "hover:bg-grey-dark" "text-black" "text-grey" "border-grey" "focus:border-grey"

        Green ->
            ColorAttributes "bg-green" "hover:bg-green-dark" "text-white" "text-green" "border-green" "focus:border-green"

        Pink ->
            ColorAttributes "bg-pink" "hover:bg-pink-dark" "text-white" "text-pink" "border-pink" "focus:border-pink"

        Purple ->
            ColorAttributes "bg-purple" "hover:bg-purple-dark" "text-white" "text-purple" "border-purple" "focus:border-purple"

        Red ->
            ColorAttributes "bg-red" "hover:bg-red-dark" "text-white" "text-red" "border-red" "focus:border-red"

        White ->
            ColorAttributes "bg-white" "hover:bg-white-dark" "text-black" "text-white-dark" "border-white-dark" "focus:border-white-dark"

        Yellow ->
            ColorAttributes "bg-yellow" "hover:bg-yellow-dark" "text-yellow-darkest" "text-yellow" "border-yellow" "focus:border-yellow"
