module Update exposing (Msg(..), update)

import Api exposing (getEvolutionChain, getPokemon, getPokemons, getSpecie)
import Debug
import Http
import Model exposing (FullPokemon, MiniPokemon, Model, Pokemon, Specie)
import RemoteData exposing (RemoteData(..))
import Set
import Task exposing (Task)
import Debounce exposing (Debounce)


type Msg
    = SearchInputTyped String
    | SearchInputDebounced Debounce.Msg
    | SearchInputChanged String
    | PokemonLoaded (Result Http.Error FullPokemon)
    | SearchPokemons
    | PokemonsLoaded (Result Http.Error (List MiniPokemon))
    | ImageError Int
    | PokemonClicked Int String

debounceConfig : Debounce.Config Msg
debounceConfig =
  { strategy = Debounce.later 500
  , transform = SearchInputDebounced
  }


flippedAndThen : Task x a -> (a -> Task x b) -> Task x b
flippedAndThen value function =
    Task.andThen function value


getFullPokemon : String -> Cmd Msg
getFullPokemon name =
    let
        request =
            getPokemon (String.toLower name)
    in
    Task.attempt PokemonLoaded <|
        flippedAndThen request <|
            \pokemon ->
                flippedAndThen (getSpecie pokemon) <|
                    \specie -> Task.succeed (FullPokemon pokemon specie)

emitSearchInputChanged: String -> Cmd Msg
emitSearchInputChanged text =
    Task.perform SearchInputChanged (Task.succeed text)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInputTyped text ->
            let
                (debounce, cmd) =
                    Debounce.push debounceConfig text model.debounce
            in
                ({model | debounce = debounce}, cmd)

        SearchInputDebounced msg_ ->
            let
                (debounce, cmd) =
                    Debounce.update
                        debounceConfig
                        (Debounce.takeLast emitSearchInputChanged)
                        msg_
                        model.debounce
            in
                ({ model | debounce = debounce}, cmd)

        SearchInputChanged text ->
            ({ model | searchText = text }, Cmd.none)

        PokemonLoaded (Ok fullPokemon) ->
            ( { model | fullPokemon = Success fullPokemon }
            , Cmd.none
            )

        PokemonLoaded (Err error) ->
            ( { model | fullPokemon = Failure error }, Cmd.none )

        SearchPokemons ->
            ( { model | pokemons = Loading }, Http.send PokemonsLoaded getPokemons )

        PokemonsLoaded (Ok pokemons) ->
            ( { model | pokemons = Success pokemons }, Cmd.none )

        PokemonsLoaded (Err error) ->
            ( { model | pokemons = Failure error }, Cmd.none )

        ImageError index ->
            ( { model | imageErrors = Set.insert index model.imageErrors }, Cmd.none )

        PokemonClicked index name ->
            ( { model | fullPokemon = Loading, selectedPokemonIndex = index }
            , getFullPokemon name
            )
