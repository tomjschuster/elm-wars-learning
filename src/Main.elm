module Main exposing (main)

import Browser
import Html
    exposing
        ( Html
        , button
        , div
        , h1
        , text
        )
import Html.Attributes exposing (src, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD
import People
import Planets
import Url.Builder


---- MODEL ----


type alias Model =
    { page : Page }


type Page
    = PeoplePage People.Model
    | PlanetsPage Planets.Model


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
    | PlanetsMsg Planets.Msg
    | GoToPeople
    | GoToPlanets


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

                _ ->
                    ( model, Cmd.none )

        PlanetsMsg subMsg ->
            case model.page of
                PlanetsPage subModel ->
                    let
                        ( updatedSubModel, cmd ) =
                            Planets.update subMsg subModel
                    in
                    ( { model | page = PlanetsPage updatedSubModel }
                    , Cmd.map PlanetsMsg cmd
                    )

                _ ->
                    ( model, Cmd.none )

        GoToPeople ->
            let
                ( subModel, cmd ) =
                    People.init
            in
            ( { model | page = PeoplePage subModel }, Cmd.map PeopleMsg cmd )

        GoToPlanets ->
            let
                ( subModel, cmd ) =
                    Planets.init
            in
            ( { model | page = PlanetsPage subModel }, Cmd.map PlanetsMsg cmd )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm Wars!" ]
        , button [ onClick GoToPeople ]
            [ text "People" ]
        , button [ onClick GoToPlanets ]
            [ text "Plane" ]
        , viewPage model.page
        ]


viewPage : Page -> Html Msg
viewPage page =
    case page of
        PeoplePage subModel ->
            Html.map PeopleMsg (People.view subModel)

        PlanetsPage subModel ->
            Html.map PlanetsMsg (Planets.view subModel)



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
