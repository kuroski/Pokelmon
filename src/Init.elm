module Init exposing (init)

import Http
import Api exposing (getPokemons)
import Update exposing (Msg(..))
import Model exposing (Model, PokeColor(..), PokeType(..))
import RemoteData exposing (RemoteData(..))
import Set

initialModel : Model
initialModel =
    { searchInput = ""
    , fullPokemon = NotAsked
    , pokemons = NotAsked
    , evolution = NotAsked
    , imageErrors = Set.empty
    }


init : a -> ( Model, Cmd Msg )
init _ =
    ( initialModel, (Http.send PokemonsLoaded getPokemons) )
