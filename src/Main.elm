module Main exposing (main)

import Browser exposing (document)
import Init exposing (init)
import Model exposing (Model)
import Subs exposing (subs)
import Update exposing (Msg, update)
import View exposing (view)


main : Program () Model Msg
main =
    document
        { init = init
        , view = view
        , update = update
        , subscriptions = subs
        }
