module RandomNumber exposing (main)

import Html exposing (..)
import Html.Events exposing (onClick)
import Random
import Browser
import Random.List exposing (shuffle)


type alias Model =
    List String

-- empty flags, needed for Browser.element
type alias Flags =
    ()

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( ["hello", "koe", "geit", "aap"], Cmd.none )

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Shuffle ] [ text "shuffle list " ]
        , text (Debug.toString model)
        ]

type Msg
    = Shuffle | ShuffledDone (List String)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Shuffle ->
            ( model, Random.generate ShuffledDone (shuffle model) )

        ShuffledDone shuffledList ->
            ( shuffledList, Cmd.none)


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
