module Init exposing (init)

import Api exposing (getPokemons)
import Http
import Model exposing (Model, PokeColor(..), PokeType(..))
import RemoteData exposing (RemoteData(..))
import Set
import Update exposing (Msg(..))


initialModel : Model
initialModel =
    { fullPokemon = NotAsked
    , pokemons = NotAsked
    , evolution = NotAsked
    , imageErrors = Set.empty
    }


init : a -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Http.send PokemonsLoaded getPokemons )
