module Init exposing (init)

import Model exposing (Model)
import RemoteData exposing (RemoteData(..))


initialModel : Model
initialModel =
    { searchInput = ""
    , fullPokemon = NotAsked
    , evolution = NotAsked
    }


init : a -> ( Model, Cmd b )
init _ =
    ( initialModel, Cmd.none )
