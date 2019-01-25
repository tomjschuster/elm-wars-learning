module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Http
import Json.Decode as JD
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
    , homeworldUrl : String
    }


personDecoder : JD.Decoder Person
personDecoder =
    JD.map5 Person
        (JD.field "url" JD.string)
        (JD.field "name" JD.string)
        (JD.field "height" JD.int)
        (JD.field "eye_color" (JD.map eyeColorFromString JD.string))
        (JD.field "homeworld" JD.string)


type EyeColor
    = Blue
    | Brown
    | Green
    | Other


eyeColorFromString : String -> EyeColor
eyeColorFromString eyeColor =
    case eyeColor of
        "Blue" ->
            Blue

        "Brown" ->
            Brown

        "Green" ->
            Green

        _ ->
            Other



---- UPDATE ----


type Msg
    = NoOp
    | InputSearchText String
    | SearchPeople
    | PeopleSearched (Result Http.Error (List Person))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        InputSearchText searchText ->
            ( { model | searchText = searchText }, Cmd.none )

        SearchPeople ->
            ( model, searchPeople model.searchText )

        PeopleSearched (Ok people) ->
            ( { model | people = people, error = Nothing }, Cmd.none )

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
        , expect =
            Http.expectJson PeopleSearched
                (JD.field "results" (JD.list personDecoder))
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
