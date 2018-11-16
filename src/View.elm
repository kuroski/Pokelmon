module View exposing (view)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onSubmit)
import Json.Decode
import Model exposing (FullPokemon, MiniPokemon, Model, PokeColor(..), PokeType(..), Specie)
import RemoteData
import Set exposing (Set)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttribute
import Update exposing (Msg(..))
import View.Helpers exposing (ColorAttributes, pokeColorAttributes)


view : Model -> Document Msg
view model =
    let
        pokeName =
            model.fullPokemon
                |> RemoteData.map .pokemon
                |> RemoteData.map (.name >> (++) "Pokelmon | ")
                |> RemoteData.withDefault "Pokelmon"
    in
    { title = pokeName
    , body =
        [ searchInput model.searchText
        , pokedex model
        ]
    }


searchInput : String -> Html Msg
searchInput searchText =
    div [ class "flex justify-center mx-auto mt-4 px-4" ]
        [ input
            [ class "shadow appearance-none border rounded-l py-2 px-3 leading-tight flex-1"
            , onInput SearchInputTyped
            , autofocus True
            ]
            [ text searchText ]
        ]


pokedex : Model -> Html Msg
pokedex model =
    let
        filteredPokemons =
            RemoteData.map
                (\pokemons ->
                    List.filter
                        (.name
                            >> String.toLower
                            >> String.contains (String.toLower model.searchText)
                        )
                        pokemons
                )
                model.pokemons
    in
    case filteredPokemons of
        RemoteData.Success pokemons ->
            div [ class "mx-auto pokegrid" ]
                (List.indexedMap (pokemonMiniView model) pokemons)

        RemoteData.Loading ->
            viewLoading

        RemoteData.Failure _ ->
            viewFailure

        RemoteData.NotAsked ->
            div [] []


pokemonMiniView : Model -> Int -> MiniPokemon -> Html Msg
pokemonMiniView model index pokemon =
    div [ class "relative" ]
        [ div
            [ class "pokeMini flex items-center justify-center flex-col cursor-pointer hover:shadow-lg rounded-full"
            , onClick <| PokemonClicked index pokemon.name
            ]
            [ pokemonImageView model.imageErrors index pokemon.name
            ]
        , div []
            [ case ( model.fullPokemon, model.selectedPokemonIndex == index ) of
                ( RemoteData.Success fullPokemon, True ) ->
                    pokeView fullPokemon (pokeColorAttributes fullPokemon.specie.color)

                ( RemoteData.Loading, True ) ->
                    viewLoading

                _ ->
                    text ""
            ]
        ]


pokemonImageView : Set Int -> Int -> String -> Html Msg
pokemonImageView set index name =
    let
        imageSrc =
            if Set.member index set then
                "https://cdn.bulbagarden.net/upload/9/98/Missingno_RB.png"

            else
                "https://img.pokemondb.net/sprites/sun-moon/icon/" ++ name ++ ".png"
    in
    img
        [ src imageSrc
        , on "error" (Json.Decode.succeed <| ImageError index)
        , class "pokeImage"
        ]
        []


viewFailure : Html Msg
viewFailure =
    div []
        [ div
            [ class "p-2 bg-indigo-darker items-center text-indigo-lightest leading-none rounded-full flex"
            ]
            [ span
                [ class "font-semibold mr-2 flex-auto text-center"
                ]
                [ text "No pokemon found" ]
            ]
        ]


viewLoading : Html Msg
viewLoading =
    div [ class "ball-beat flex justify-center absolute w-full" ]
        [ div [] []
        , div [] []
        , div [] []
        ]


pokeView : FullPokemon -> ColorAttributes -> Html Msg
pokeView fullPokemon colorAttributes =
    let
        cardClasses =
            String.join " "
                [ "pokeView"
                , colorAttributes.color
                , colorAttributes.border
                , "border-solid"
                , "border-2"
                , "rounded-lg"
                , "absolute"
                , "shadow-lg"
                , "p-4"
                , "flex"
                , "flex-col"
                , "justify-between"
                , "bg-white"
                , "z-10"
                , "w-64"
                ]
    in
    div [ class cardClasses ]
        [ pokemonBaseView fullPokemon colorAttributes
        , div [ class "mt-2" ]
            [ div [ class "flex justify-center font-thin text-sm mb-2" ]
                [ div [ class "flex items-center mr-4" ]
                    [ i [ class "fas fa-text-height mr-2" ] []
                    , div [] [ text <| String.fromFloat fullPokemon.pokemon.height ++ " (m)" ]
                    ]
                , div [ class "flex items-center" ]
                    [ i [ class "fas fa-weight mr-2" ] []
                    , div [] [ text <| String.fromFloat fullPokemon.pokemon.weight ++ " (kg)" ]
                    ]
                ]
            , div [ class "font-light text-justify" ] [ text fullPokemon.specie.flavorText ]
            ]
        ]


pokemonBaseView : FullPokemon -> ColorAttributes -> Html Msg
pokemonBaseView fullPokemon colorAttributes =
    let
        iconClasses =
            String.join " "
                [ colorAttributes.color
                , "fill-current"
                ]
    in
    div [ class "text-center" ]
        [ img [ src <| "https://img.pokemondb.net/artwork/" ++ fullPokemon.pokemon.name ++ ".jpg" ] []
        , div [ class "flex items-center justify-center" ]
            [ svg
                [ SvgAttribute.class iconClasses
                , SvgAttribute.width "20"
                , SvgAttribute.height "20"
                ]
                [ path [ SvgAttribute.d "M 10.003906 1.890625 C 5.945312 1.894531 2.582031 4.871094 1.976562 8.761719 L 6.105469 8.769531 C 6.632812 7.117188 8.179688 5.925781 10.003906 5.921875 C 11.824219 5.925781 13.367188 7.117188 13.898438 8.765625 L 18.023438 8.769531 C 17.421875 4.875 14.0625 1.894531 10.003906 1.890625 Z M 10.003906 7.359375 C 8.535156 7.359375 7.34375 8.550781 7.34375 10.019531 C 7.34375 11.484375 8.535156 12.675781 10.003906 12.675781 C 11.46875 12.675781 12.660156 11.484375 12.660156 10.019531 C 12.660156 8.550781 11.46875 7.359375 10.003906 7.359375 Z M 1.980469 11.269531 C 2.582031 15.160156 5.945312 18.140625 10.003906 18.144531 C 14.058594 18.140625 17.421875 15.164062 18.027344 11.277344 L 13.898438 11.269531 C 13.371094 12.917969 11.828125 14.113281 10.003906 14.113281 C 8.179688 14.109375 6.636719 12.917969 6.109375 11.273438 Z M 1.980469 11.269531" ] []
                ]
            , div [ class "font-light text-xl" ] [ text <| String.fromInt fullPokemon.pokemon.order ]
            ]
        , div [ class "uppercase font-normal text-3xl" ] [ text fullPokemon.pokemon.name ]
        , div [ class "text-xs mb-2" ] [ text fullPokemon.specie.genera ]
        , div [ class "flex items-center justify-center" ]
            [ pokeTypeView (Just fullPokemon.pokemon.pokeType1)
            , pokeTypeView fullPokemon.pokemon.pokeType2
            ]
        ]


pokeTypeView : Maybe PokeType -> Html msg
pokeTypeView maybePokeType =
    case maybePokeType of
        Just Normal ->
            div [ class "type type--normal" ] []

        Just Fighting ->
            div [ class "type type--fighting" ] []

        Just Flying ->
            div [ class "type type--flying" ] []

        Just Poison ->
            div [ class "type type--poison" ] []

        Just Ground ->
            div [ class "type type--ground" ] []

        Just Rock ->
            div [ class "type type--rock" ] []

        Just Bug ->
            div [ class "type type--bug" ] []

        Just Ghost ->
            div [ class "type type--ghost" ] []

        Just Steel ->
            div [ class "type type--steel" ] []

        Just Fire ->
            div [ class "type type--fire" ] []

        Just Water ->
            div [ class "type type--water" ] []

        Just Grass ->
            div [ class "type type--grass" ] []

        Just Electric ->
            div [ class "type type--electric" ] []

        Just Psychic ->
            div [ class "type type--psychic" ] []

        Just Ice ->
            div [ class "type type--ice" ] []

        Just Dragon ->
            div [ class "type type--dragon" ] []

        Just Dark ->
            div [ class "type type--dark" ] []

        Just Fairy ->
            div [ class "type type--fairy" ] []

        Just Unknown ->
            div [ class "type type--unknown" ] []

        Just Shadow ->
            div [] [ text "Shadow" ]

        Nothing ->
            div [] []
