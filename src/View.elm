module View exposing (view)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import RemoteData
import Model exposing (Model, PokeColor(..), PokeType(..), Pokemon, Specie)
import Update exposing (Msg(..))

fullPokemon : Model -> RemoteData.WebData (Pokemon, Specie)
fullPokemon model =
    RemoteData.map2 (\pokemon specie -> (pokemon, specie)) model.pokemon model.specie


view : Model -> Document Msg
view model =
    let
        pokeName =
            model.pokemon
                |> RemoteData.map (.name >> (++) "Pokelmon | ")
                |> RemoteData.withDefault "Pokelmon"

        pokemon = fullPokemon model
    in
    { title = pokeName
    , body =
        [ div [ class "container max-w-sm mx-auto my-4" ]
            [ viewSearchInput model
            , pokeView pokemon
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
            [ class "shadow border-b border-t bg-purple hover:bg-purple-dark text-white leading-tight font-bold py-2 px-4 rounded-r-lg"
            , type_ "submit"
            ]
            [ viewSearchButtonIcon <| RemoteData.isLoading <| fullPokemon model
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


pokeView : RemoteData.WebData (Pokemon, Specie) -> Html Msg
pokeView webDataFullPokemon =
    case webDataFullPokemon of
        RemoteData.Success (pokemon, specie) ->
            div []
                [ img [ src pokemon.image ] []
                , img [ src pokemon.imageBack ] []
                , p [] [ text pokemon.name ]
                , p [] [ text <| "#" ++ String.fromInt pokemon.order ]
                , pokeTypeView (Just pokemon.pokeType1)
                , pokeTypeView pokemon.pokeType2
                , p [] [ text <| "Height (m) " ++ String.fromFloat pokemon.height ]
                , p [] [ text <| "Weight (kg) " ++ String.fromFloat pokemon.weight ]
                , specieView specie
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
        , p []
            [ text "Color: "
            , pokeColorView specie.color
            ]
        ]


pokeColorView : PokeColor -> Html msg
pokeColorView pokeColor =
    case pokeColor of
        Black ->
            div [] [ text "Black" ]

        Blue ->
            div [] [ text "Blue" ]

        Brown ->
            div [] [ text "Brown" ]

        Gray ->
            div [] [ text "Gray" ]

        Green ->
            div [] [ text "Green" ]

        Pink ->
            div [] [ text "Pink" ]

        Purple ->
            div [] [ text "Purple" ]

        Red ->
            div [] [ text "Red" ]

        White ->
            div [] [ text "White" ]

        Yellow ->
            div [] [ text "Yellow" ]


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
