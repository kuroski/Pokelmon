module Model exposing (Model, PokeColor(..), PokeType(..), Pokemon, Specie)

import RemoteData exposing (WebData)

type PokeType
    = Normal
    | Fighting
    | Flying
    | Poison
    | Ground
    | Rock
    | Bug
    | Ghost
    | Steel
    | Fire
    | Water
    | Grass
    | Electric
    | Psychic
    | Ice
    | Dragon
    | Dark
    | Fairy
    | Unknown
    | Shadow


type PokeColor
    = Black
    | Blue
    | Brown
    | Gray
    | Green
    | Pink
    | Purple
    | Red
    | White
    | Yellow


type alias Pokemon =
    { name : String
    , order : Int
    , height : Float
    , weight : Float
    , pokeType1 : PokeType
    , pokeType2 : Maybe PokeType
    , image : String
    , imageBack : String
    , imageFemale : Maybe String
    , specieUrl : String
    }


type alias Specie =
    { color : PokeColor
    , genera : String
    , flavorText : String
    , evolutionChainUrl : String
    }


type alias Model =
    { searchInput : String
    , pokemon : WebData Pokemon
    , specie : WebData Specie
    , evolution : WebData String
    }
