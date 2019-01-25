module Person exposing (EyeColor, Person, decoder, eyeColorToString)

import Json.Decode as JD


type alias Person =
    { url : String
    , name : String
    , height : Int
    , eyeColor : EyeColor
    , homeworldUrl : String
    }


decoder : JD.Decoder Person
decoder =
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
