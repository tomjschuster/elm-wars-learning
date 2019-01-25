module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)


---- MODEL ----


type alias Model =
    { people : List Person, searchText : String }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { people = [], searchText = "" }


type alias Person =
    { url : String
    , name : String
    , height : Int
    , eyeColor : EyeColor
    , homeworld : Planet
    }


type EyeColor
    = Blue
    | Brown
    | Green
    | Other


type alias Planet =
    { url : String
    , name : String
    , population : Int
    }



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
