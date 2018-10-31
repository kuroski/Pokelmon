module View exposing (view)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Model exposing (FullPokemon, Model, PokeColor(..), PokeType(..), Specie)
import RemoteData
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
        [ div
            [ class "container max-w-sm mx-auto my-4" ]
            (body model)
        ]
    }


body : Model -> List (Html Msg)
body model =
    case model.fullPokemon of
        RemoteData.Success fullPokemon ->
            [ viewSearchInput False model.searchInput (pokeColorAttributes fullPokemon.specie.color)
            , pokeView fullPokemon (pokeColorAttributes fullPokemon.specie.color)
            ]

        RemoteData.Loading ->
            [ viewSearchInput True model.searchInput (pokeColorAttributes Purple)
            , viewLoading
            ]

        RemoteData.Failure _ ->
            [ viewSearchInput False model.searchInput (pokeColorAttributes Purple)
            , viewFailure
            ]

        RemoteData.NotAsked ->
            [ viewSearchInput False model.searchInput (pokeColorAttributes Purple)
            , viewNotAsked
            ]


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


viewNotAsked : Html Msg
viewNotAsked =
    div [] []


viewSearchInput : Bool -> String -> ColorAttributes -> Html Msg
viewSearchInput isLoading searchInput { background, hover, text, color, focusBorder } =
    let
        inputColorClass =
            String.join " "
                [ color
                , focusBorder
                , "shadow"
                , "appearance-none"
                , "border"
                , "rounded-l"
                , "py-2"
                , "px-3"
                , "leading-tight"
                , "flex-1"
                ]

        submitColorClass =
            String.join " "
                [ background
                , hover
                , text
                , "shadow"
                , "border-b"
                , "border-t"
                , "text-white"
                , "leading-tight"
                , "font-bold"
                , "py-2"
                , "px-4"
                , "rounded-r-lg"
                ]
    in
    Html.form
        [ onSubmit SearchPokemon
        , class "mb-8 flex items-center"
        ]
        [ input
            [ type_ "text"
            , placeholder "Search your pokemon"
            , value searchInput
            , autofocus True
            , onInput SetSearchInput
            , class inputColorClass
            , disabled isLoading
            ]
            []
        , button
            [ class submitColorClass
            , type_ "submit"
            ]
            [ viewSearchButtonIcon isLoading
            ]
        ]


viewSearchButtonIcon : Bool -> Html Msg
viewSearchButtonIcon isLoading =
    i
        [ classList
            [ ( "fas fa-spinner fa-pulse", isLoading )
            , ( "fas fa-search", not isLoading )
            ]
        ]
        []


viewLoading : Html Msg
viewLoading =
    div [ class "flex justify-center" ]
        [ i
            [ class "fas fa-3x fa-spinner fa-pulse mb-4" ]
            []
        ]


pokeView : FullPokemon -> ColorAttributes -> Html Msg
pokeView fullPokemon colorAttributes =
    let
        cardClasses =
            String.join " "
                [ colorAttributes.color
                , colorAttributes.border
                , "border-solid"
                , "border-2"
                , "max-w-sm"
                , "rounded-lg"
                , "overflow-hidden"
                , "shadow-lg"
                , "p-6"
                , "flex"
                , "flex-col"
                , "items-center"
                ]
    in
    div [ class cardClasses ]
        [ pokemonBaseView fullPokemon colorAttributes
        , pokeTypeView (Just fullPokemon.pokemon.pokeType1)
        , pokeTypeView fullPokemon.pokemon.pokeType2
        , p [] [ text <| "Height (m) " ++ String.fromFloat fullPokemon.pokemon.height ]
        , p [] [ text <| "Weight (kg) " ++ String.fromFloat fullPokemon.pokemon.weight ]
        , specieView fullPokemon.specie
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
    div [ class "mb-5 text-center" ]
        [ div [ class "flex items-center justify-center" ]
            [ svg
                [ SvgAttribute.class iconClasses
                , SvgAttribute.width "20"
                , SvgAttribute.height "20"
                ]
                [ path [ SvgAttribute.d "M 10.003906 1.890625 C 5.945312 1.894531 2.582031 4.871094 1.976562 8.761719 L 6.105469 8.769531 C 6.632812 7.117188 8.179688 5.925781 10.003906 5.921875 C 11.824219 5.925781 13.367188 7.117188 13.898438 8.765625 L 18.023438 8.769531 C 17.421875 4.875 14.0625 1.894531 10.003906 1.890625 Z M 10.003906 7.359375 C 8.535156 7.359375 7.34375 8.550781 7.34375 10.019531 C 7.34375 11.484375 8.535156 12.675781 10.003906 12.675781 C 11.46875 12.675781 12.660156 11.484375 12.660156 10.019531 C 12.660156 8.550781 11.46875 7.359375 10.003906 7.359375 Z M 1.980469 11.269531 C 2.582031 15.160156 5.945312 18.140625 10.003906 18.144531 C 14.058594 18.140625 17.421875 15.164062 18.027344 11.277344 L 13.898438 11.269531 C 13.371094 12.917969 11.828125 14.113281 10.003906 14.113281 C 8.179688 14.109375 6.636719 12.917969 6.109375 11.273438 Z M 1.980469 11.269531" ] []
                ]
            , div [ class "font-light text-xl" ] [ text (String.fromInt fullPokemon.pokemon.order) ]
            ]
        , div [ class "uppercase font-normal text-3xl" ] [ text fullPokemon.pokemon.name ]
        , div [ class "text-xs mb-4" ] [ text fullPokemon.specie.genera ]
        , img [ width 250, height 250, src ("https://img.pokemondb.net/artwork/" ++ fullPokemon.pokemon.name ++ ".jpg") ] []
        ]


specieView : Specie -> Html Msg
specieView specie =
    div []
        [ p [] [ text ("Flavor text: " ++ specie.flavorText) ]
        ]


pokeTypeView : Maybe PokeType -> Html msg
pokeTypeView maybePokeType =
    case maybePokeType of
        Just Normal ->
            div [] [ text "Normal" ]

        Just Fighting ->
            div [] [ text "Fighting" ]

        Just Flying ->
            div [] [ text "Flying" ]

        Just Poison ->
            div [] [ text "Poison" ]

        Just Ground ->
            div [] [ text "Ground" ]

        Just Rock ->
            div [] [ text "Rock" ]

        Just Bug ->
            div [] [ text "Bug" ]

        Just Ghost ->
            div [] [ text "Ghost" ]

        Just Steel ->
            div [] [ text "Steel" ]

        Just Fire ->
            div [] [ text "Fire" ]

        Just Water ->
            div [] [ text "Water" ]

        Just Grass ->
            div [] [ text "Grass" ]

        Just Electric ->
            div [] [ text "Electric" ]

        Just Psychic ->
            div [] [ text "Psychic" ]

        Just Ice ->
            div [] [ text "Ice" ]

        Just Dragon ->
            div [] [ text "Dragon" ]

        Just Dark ->
            div [] [ text "Dark" ]

        Just Fairy ->
            div [] [ text "Fairy" ]

        Just Unknown ->
            div [] [ text "Unknown" ]

        Just Shadow ->
            div [] [ text "Shadow" ]

        Nothing ->
            div [] []
