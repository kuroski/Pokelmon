module Model exposing (FullPokemon, MiniPokemon, Model, PokeColor(..), PokeType(..), Pokemon, Specie)

import RemoteData exposing (WebData)
import Set exposing (Set)

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
    | Grey
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


type alias FullPokemon =
    { pokemon : Pokemon
    , specie : Specie
    }


type alias MiniPokemon =
    { name : String
    , pokeUrl : String
    }


type alias Model =
    { searchInput : String
    , fullPokemon : WebData FullPokemon
    , pokemons : WebData (List MiniPokemon)
    , evolution : WebData String
    , imageErrors : Set Int
    }