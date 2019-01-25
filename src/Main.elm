module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Http
import Url.Builder


---- MODEL ----


type alias Model =
    { people : List Person
    , searchText : String
    , error : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { people = []
    , searchText = ""
    , error = Nothing
    }


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
    | InputSearchText String
    | SearchPeople
    | PeopleSearched (Result Http.Error ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        InputSearchText searchText ->
            ( { model | searchText = searchText }, Cmd.none )

        SearchPeople ->
            ( model, searchPeople model.searchText )

        PeopleSearched (Ok ()) ->
            ( { model | error = Nothing }, Cmd.none )

        PeopleSearched (Err err) ->
            ( { model | error = Just (Debug.toString err) }, Cmd.none )



-- Requests


baseApi : String
baseApi =
    "https://swapi.co/api"


searchPeopleUrl : String -> String
searchPeopleUrl searchText =
    Url.Builder.crossOrigin baseApi
        [ "people" ]
        [ Url.Builder.string "name" searchText ]


searchPeople : String -> Cmd Msg
searchPeople searchText =
    Http.get
        { url = searchPeopleUrl searchText
        , expect = Http.expectWhatever PeopleSearched
        }



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
