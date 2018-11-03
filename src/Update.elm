module Update exposing (Msg(..), update)

import Api exposing (getEvolutionChain, getPokemon, getSpecie, getPokemons)
import Http
import Model exposing (FullPokemon, MiniPokemon, Model, Pokemon, Specie)
import RemoteData exposing (RemoteData(..))
import Task exposing (Task)


type Msg
    = SetSearchInput String
    | SearchPokemon
    | PokemonLoaded (Result Http.Error FullPokemon)
    | SearchPokemons
    | PokemonsLoaded (Result Http.Error (List MiniPokemon))


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
            , Task.attempt PokemonLoaded <|
                flippedAndThen request <|
                    \pokemon ->
                        flippedAndThen (getSpecie pokemon) <|
                            \specie -> Task.succeed (FullPokemon pokemon specie)
            )

        PokemonLoaded (Ok fullPokemon) ->
            ( { model | fullPokemon = Success fullPokemon }
            , Cmd.none
            )

        PokemonLoaded (Err error) ->
            ( { model | fullPokemon = Failure error }, Cmd.none )

        SearchPokemons ->
            ( { model | pokemons = Loading }, (Http.send PokemonsLoaded getPokemons) )

        PokemonsLoaded ( Ok pokemons ) ->
            ( { model | pokemons = Success pokemons }, Cmd.none )

        PokemonsLoaded ( Err error ) ->
            ( { model | pokemons = Failure error }, Cmd.none )
