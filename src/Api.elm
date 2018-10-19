module Api exposing (getPokemon, getSpecie, getEvolutionChain)

import Http
import Json.Decode as Decode exposing (Decoder, int, nullable, string, at)
import Json.Decode.Pipeline exposing (optionalAt, required, requiredAt)
import Model exposing (PokeColor(..), PokeType(..), Pokemon, Specie)
import Task exposing (Task)


evolutionChainDecoder : Decoder String
evolutionChainDecoder =
    at [ "chain", "evolves_to", "0", "species", "name" ] string


specieDecoder : Decoder Specie
specieDecoder =
    Decode.succeed Specie
        |> requiredAt [ "color", "name" ] colorDecoder
        |> requiredAt [ "genera", "2", "genus" ] string
        |> requiredAt [ "flavor_text_entries", "2", "flavor_text" ] string
        |> requiredAt [ "evolution_chain", "url" ] string


colorDecoder : Decoder PokeColor
colorDecoder =
    let
        stringMapper =
            \s ->
                case s of
                    "black" ->
                        Decode.succeed Black

                    "blue" ->
                        Decode.succeed Blue

                    "brown" ->
                        Decode.succeed Brown

                    "gray" ->
                        Decode.succeed Gray

                    "green" ->
                        Decode.succeed Green

                    "pink" ->
                        Decode.succeed Pink

                    "purple" ->
                        Decode.succeed Purple

                    "red" ->
                        Decode.succeed Red

                    "white" ->
                        Decode.succeed White

                    "yellow" ->
                        Decode.succeed Yellow

                    _ ->
                        Decode.fail "No color found"
    in
    Decode.andThen stringMapper string


pokeDecoder : Decoder Pokemon
pokeDecoder =
    Decode.succeed Pokemon
        |> required "name" string
        |> required "order" int
        |> required "height" sizeDecoder
        |> required "weight" sizeDecoder
        |> requiredAt [ "types", "0", "type", "name" ] typeDecoder
        |> optionalAt [ "types", "1", "type", "name" ] (nullable typeDecoder) Nothing
        |> requiredAt [ "sprites", "front_default" ] string
        |> requiredAt [ "sprites", "back_default" ] string
        |> requiredAt [ "sprites", "front_female" ] (nullable string)
        |> requiredAt [ "species", "url" ] string


sizeDecoder : Decoder Float
sizeDecoder =
    Decode.map (\i -> toFloat i / 10) int


typeDecoder : Decoder PokeType
typeDecoder =
    let
        stringMapper =
            \s ->
                case s of
                    "normal" ->
                        Decode.succeed Normal

                    "fighting" ->
                        Decode.succeed Fighting

                    "flying" ->
                        Decode.succeed Flying

                    "poison" ->
                        Decode.succeed Poison

                    "ground" ->
                        Decode.succeed Ground

                    "rock" ->
                        Decode.succeed Rock

                    "bug" ->
                        Decode.succeed Bug

                    "ghost" ->
                        Decode.succeed Ghost

                    "steel" ->
                        Decode.succeed Steel

                    "fire" ->
                        Decode.succeed Fire

                    "water" ->
                        Decode.succeed Water

                    "grass" ->
                        Decode.succeed Grass

                    "electric" ->
                        Decode.succeed Electric

                    "psychic" ->
                        Decode.succeed Psychic

                    "ice" ->
                        Decode.succeed Ice

                    "dragon" ->
                        Decode.succeed Dragon

                    "dark" ->
                        Decode.succeed Dark

                    "fairy" ->
                        Decode.succeed Fairy

                    "unknown" ->
                        Decode.succeed Unknown

                    "shadow" ->
                        Decode.succeed Shadow

                    _ ->
                        Decode.fail "No poketype found"
    in
    Decode.andThen stringMapper string


getPokemon : String -> Http.Request Pokemon
getPokemon term =
    let
        url =
            "https://pokeapi.co/api/v2/pokemon/" ++ term ++ "/"
    in
    Http.get url pokeDecoder



getSpecie : Pokemon -> Http.Request Specie
getSpecie pokemon =
    Http.get pokemon.specieUrl specieDecoder



getEvolutionChain : Specie -> Http.Request String
getEvolutionChain specie =
    Http.get specie.evolutionChainUrl evolutionChainDecoder
