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
        (JD.field "height"
            (JD.andThen (String.toInt >> failOnNothing) JD.string)
        )
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


eyeColorToString : EyeColor -> String
eyeColorToString eyeColor =
    case eyeColor of
        Blue ->
            "Blue"

        Brown ->
            "Brown"

        Green ->
            "Green"

        Other ->
            "Other"


failOnNothing : Maybe a -> JD.Decoder a
failOnNothing maybe =
    case maybe of
        Just a ->
            JD.succeed a

        Nothing ->
            JD.fail "Nothing"



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
        [ h1 [] [ text "Elm Wars!" ]
        , button [ onClick SearchPeople ] [ text "Search: " ]
        , input
            [ type_ "text"
            , value model.searchText
            , onInput InputSearchText
            ]
            []
        , viewResults model.error model.people
        ]


viewResults : Maybe String -> List Person -> Html Msg
viewResults error people =
    case error of
        Just message ->
            p [] [ text message ]

        Nothing ->
            ul [] (List.map personItem people)


personItem : Person -> Html Msg
personItem person =
    li []
        [ p [] [ text ("Name: " ++ person.name) ]
        , p [] [ text ("Height: " ++ String.fromInt person.height) ]
        , p [] [ text ("Eye Color: " ++ eyeColorToString person.eyeColor) ]
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
