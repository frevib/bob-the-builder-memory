module Main exposing (Model, Msg(..), imageRecords, init, main, split, squares, styleFlexBox, update, view)

import Array exposing (Array, indexedMap)
import Browser
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (height, src, style, width)
import Html.Events exposing (onClick)
import List exposing (drop, take)
import Random
import Random.Array
import Random.List


type alias Flags =
    ()


type alias ImageRecord =
    { id : Int, url : String, opened : Bool }


type alias Model =
    List ImageRecord


type Msg
    = --  Flip String
      Reset
    | ShuffledDone (List ImageRecord)
    | SelectSquare Int


imageRecords : List ImageRecord
imageRecords =
    let
        urls =
            [ "src/img/bob_the_builder_01.jpeg"
            , "src/img/dizzy.jpeg"
            , "src/img/rollie.jpeg"
            , "src/img/muck.jpeg"
            , "src/img/benny.jpeg"
            , "src/img/scoop.jpeg"
            ]
    in
    urls
        ++ urls
        -- |> Array.fromList
        |> generateImageRecords


generateImageRecords : List String -> List ImageRecord
generateImageRecords imageRecords1 =
    List.indexedMap
        (\index imageUrl ->
            ImageRecord index imageUrl False
        )
        imageRecords1



-- init


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( imageRecords
    , Random.generate ShuffledDone (Random.List.shuffle imageRecords)
    )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Flip openedImage ->
        --     if model.openedImage == "" then
        --         ( { openedImage = openedImage, message = "one more!" }
        --         , Random.generate ShuffledDone (shuffle model)
        --         )
        --     else if openedImage == model.openedImage then
        --         { openedImage = "", message = "Bingo!" }
        --     else
        --         { openedImage = "", message = "too bad :(" }
        ShuffledDone shuffledList ->
            ( shuffledList, Cmd.none )

        Reset ->
            ( model, Random.generate ShuffledDone (Random.List.shuffle imageRecords) )

        SelectSquare id ->
            ( changeModel model id, Cmd.none )


changeModel model1 id1 =
    List.map
        (\item ->
            if item.id == id1 then
                { item | opened = True }

            else
                item
        )
        model1


split : Int -> List a -> List (List a)
split i list =
    case take i list of
        [] ->
            []

        listHead ->
            listHead :: split i (drop i list)


styleFlipped opened =
    if opened then
        style "opacity" "1.0"

    else
        style "opacity" "0.5"


squares : List (List ImageRecord) -> List (Html Msg)
squares images =
    List.map
        (\innerList ->
            div
                []
                (List.map
                    (\item ->
                        div
                            [ styleFlipped item.opened
                            , style "border-style" "dotted"
                            , onClick (SelectSquare item.id)
                            ]
                            [ img [ src item.url, width 200, height 200 ] [] ]
                    )
                    innerList
                )
        )
        images



-- view


styleFlexBox : String -> List (Html.Attribute Msg)
styleFlexBox direction =
    [ style "display" "flex"
    , style "flex-direction" direction
    ]


view : Model -> Html Msg
view model =
    div (styleFlexBox "column")
        [ div (styleFlexBox "row") (squares (split 3 model))
        , button [ onClick Reset ] [ text "generate new" ]
        , div [] []
        ]


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
