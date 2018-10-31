module View exposing (view)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Model exposing (FullPokemon, Model, PokeColor(..), PokeType(..), Specie)
import RemoteData
import Update exposing (Msg(..))
import View.Helpers exposing(pokeColor)


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
        [ div [ class "container max-w-sm mx-auto my-4" ]
            [ viewSearchInput model
            , pokeView model.fullPokemon
            ]
        ]
    }


viewSearchInput : Model -> Html Msg
viewSearchInput model =
    Html.form
        [ onSubmit SearchPokemon
        , class "mb-8 flex items-center"
        ]
        [ input
            [ type_ "text"
            , placeholder "Search your pokemon"
            , value model.searchInput
            , autofocus True
            , onInput SetSearchInput
            , class "shadow appearance-none border rounded-l py-2 px-3 text-purple-darker leading-tight focus:border-purple flex-1"
            ]
            []
        , button
            [ class ("shadow border-b border-t text-white leading-tight font-bold py-2 px-4 rounded-r-lg " ++ (submitColorClass model.fullPokemon))
            , type_ "submit"
            ]
            [ viewSearchButtonIcon <| RemoteData.isLoading <| model.fullPokemon
            ]
        ]


submitColorClass : RemoteData.WebData FullPokemon -> String
submitColorClass webDataFullPokemon =
    case webDataFullPokemon of
        RemoteData.Success fullPokemon ->
            let
                { background, hover, text } = pokeColor fullPokemon.specie.color
            in
            String.join " " [background, hover, text]

        _ ->
            "bg-purple hover:bg-purple-dark"


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


pokeView : RemoteData.WebData FullPokemon -> Html Msg
pokeView webDataFullPokemon =
    case webDataFullPokemon of
        RemoteData.Success fullPokemon ->
            div []
                [ img [ src fullPokemon.pokemon.image ] []
                , img [ src fullPokemon.pokemon.imageBack ] []
                , p [] [ text fullPokemon.pokemon.name ]
                , p [] [ text <| "#" ++ String.fromInt fullPokemon.pokemon.order ]
                , pokeTypeView (Just fullPokemon.pokemon.pokeType1)
                , pokeTypeView fullPokemon.pokemon.pokeType2
                , p [] [ text <| "Height (m) " ++ String.fromFloat fullPokemon.pokemon.height ]
                , p [] [ text <| "Weight (kg) " ++ String.fromFloat fullPokemon.pokemon.weight ]
                , specieView fullPokemon.specie
                ]

        RemoteData.Loading ->
            viewLoading

        _ ->
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


specieView : Specie -> Html Msg
specieView specie =
    div []
        [ p [] [ text ("Genera: " ++ specie.genera) ]
        , p [] [ text ("Flavor text: " ++ specie.flavorText) ]
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
