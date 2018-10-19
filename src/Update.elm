module Update exposing (Msg(..), update)

import Api exposing (getEvolutionChain, getPokemon, getSpecie)
import Http
import RemoteData exposing (RemoteData(..))
import Model exposing (Model, Pokemon, Specie)
import Task exposing (Task)


type Msg
    = SetSearchInput String
    | SearchPokemon
    | PokemonLoaded (Result Http.Error Pokemon)
    | SpecieLoaded (Result Http.Error Specie)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSearchInput value ->
            ( { model | searchInput = value }, Cmd.none )

        SearchPokemon ->
            let
                request =
                    getPokemon (String.toLower model.searchInput)
            in
            ( { model | pokemon = Loading, specie = NotAsked }
            , Http.send PokemonLoaded (getPokemon (String.toLower model.searchInput))
            )

        PokemonLoaded (Ok pokemon) ->
            ( { model | pokemon = Success pokemon, specie = Loading }
            , Http.send SpecieLoaded (getSpecie pokemon)
            )

        PokemonLoaded (Err error) ->
            ( { model | pokemon = Failure error }, Cmd.none )

        SpecieLoaded (Ok specie) ->
            ( { model | specie = Success specie }, Cmd.none )

        SpecieLoaded (Err error) ->
            ( { model | specie = Failure error }, Cmd.none )
