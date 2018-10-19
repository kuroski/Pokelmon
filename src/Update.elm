module Update exposing (Msg(..), update)

import Api exposing (getEvolutionChain, getPokemon, getSpecie)
import Http
import RemoteData exposing (RemoteData(..))
import Model exposing (Model, FullPokemon, Pokemon, Specie)
import Task exposing (Task)


type Msg
    = SetSearchInput String
    | SearchPokemon
    | PokemonLoaded (Result Http.Error FullPokemon)

flippedAndThen : Task x a -> (a -> Task x b) -> Task x b
flippedAndThen value function =
    Task.andThen function value


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
            ( { model | fullPokemon = Loading }
            , Task.attempt PokemonLoaded
                <| flippedAndThen request
                <| \pokemon -> flippedAndThen (getSpecie pokemon)
                <| \specie -> Task.succeed (FullPokemon pokemon specie)
            )

        PokemonLoaded (Ok fullPokemon) ->
            ( { model | fullPokemon = Success fullPokemon }
            , Cmd.none
            )

        PokemonLoaded (Err error) ->
            ( { model | fullPokemon = Failure error }, Cmd.none )
