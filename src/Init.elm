module Init exposing (init)

import Http
import Api exposing (getPokemons)
import Update exposing (Msg(..))
import Model exposing (Model, PokeColor(..), PokeType(..))
import RemoteData exposing (RemoteData(..))
import Set

-- initialModel : Model
-- initialModel =
--     { searchInput = ""
--     , fullPokemon = NotAsked
--     , evolution = NotAsked
--     }


snorlax =
    { pokemon =
        { height = 2.1
        , image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/143.png"
        , imageBack = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/143.png"
        , imageFemale = Nothing
        , name = "snorlax"
        , order = 215
        , pokeType1 = Normal
        , pokeType2 = Nothing
        , specieUrl = "https://pokeapi.co/api/v2/pokemon-species/143/"
        , weight = 460
        }
    , specie =
        { color = Black
        , evolutionChainUrl = "https://pokeapi.co/api/v2/evolution-chain/72/"
        , flavorText = "It eats nearly 900 pounds of food every day.\nIt starts nodding off while eating—and continues\nto eat even while it’s asleep."
        , genera = "Sleeping Pokémon"
        }
    }


initialModel : Model
initialModel =
    { searchInput = "snorlax"
    , fullPokemon = Success snorlax
    , pokemons = NotAsked
    , evolution = NotAsked
    , imageErrors = Set.empty
    }


init : a -> ( Model, Cmd Msg )
init _ =
    ( initialModel, (Http.send PokemonsLoaded getPokemons) )
