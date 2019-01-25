module Planets exposing (Model, Msg, init, initialModel, update, view)

import Html
    exposing
        ( Html
        , button
        , div
        , h2
        , img
        , input
        , label
        , li
        , p
        , text
        , ul
        )
import Html.Attributes exposing (type_, value)
import Http
import Url.Builder


---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    {}



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Planets" ]
        ]
