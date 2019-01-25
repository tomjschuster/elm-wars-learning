module People exposing (Model, Msg, init, initialModel, update, view)

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
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD
import Person exposing (Person)
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
                (JD.field "results" (JD.list Person.decoder))
        }



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "People" ]
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
        , p [] [ text ("Eye Color: " ++ Person.eyeColorToString person.eyeColor) ]
        ]
