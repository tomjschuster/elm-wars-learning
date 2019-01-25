module Main exposing (main)

import Browser
import Html
    exposing
        ( Html
        , button
        , div
        , h1
        , img
        , input
        , label
        , li
        , p
        , text
        , ul
        )
import Html.Attributes exposing (src, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD
import People
import Url.Builder


---- MODEL ----


type alias Model =
    { page : Page }


type Page
    = PeoplePage People.Model


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { page = PeoplePage People.initialModel }



---- UPDATE ----


type Msg
    = NoOp
    | PeopleMsg People.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        PeopleMsg subMsg ->
            case model.page of
                PeoplePage subModel ->
                    let
                        ( updatedSubModel, cmd ) =
                            People.update subMsg subModel
                    in
                    ( { model | page = PeoplePage updatedSubModel }
                    , Cmd.map PeopleMsg cmd
                    )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm Wars!" ]
        , viewPage model.page
        ]


viewPage : Page -> Html Msg
viewPage page =
    case page of
        PeoplePage subModel ->
            Html.map PeopleMsg (People.view subModel)



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
