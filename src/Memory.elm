module Main exposing (Model, Msg(..), images, init, main, split, squares, styleFlexBox, update, view)

import Array
import Browser
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (height, src, style, width)
import Html.Events exposing (onClick)
import List exposing (drop, take)
import Random
import Random.List exposing (shuffle)


type alias Flags =
    ()


type alias ImageRecord =
    { id : Int, url : String, opened : Bool }


type alias Model =
    List ImageRecord


type Msg =
 --  Flip String
      Reset |
      ShuffledDone (List ImageRecord)


images : List String
images =
    let
        imagePaths =
            [ "src/img/bob_the_builder_01.jpeg"
            , "src/img/dizzy.jpeg"
            , "src/img/rollie.jpeg"
            , "src/img/muck.jpeg"
            , "src/img/benny.jpeg"
            , "src/img/scoop.jpeg"
            ]
    in
    imagePaths ++ imagePaths



-- init


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( generateImageRecords images
    , Random.generate ShuffledDone (shuffle (generateImageRecords images))
    )


generateImageRecords imageUrls =
    List.indexedMap
        (\index imageUrl ->
            ImageRecord index imageUrl False
        )
        imageUrls



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
            ( model, Random.generate ShuffledDone (shuffle (generateImageRecords images)))


split : Int -> List a -> List (List a)
split i list =
    case take i list of
        [] ->
            []

        listHead ->
            listHead :: split i (drop i list)


styleFlexBox : String -> List (Html.Attribute Msg)
styleFlexBox direction =
    [ style "display" "flex"
    , style "flex-direction" direction
    ]


squares : List (List ImageRecord) -> List (Html Msg)
squares imagePaths =
    List.map
        (\innerList ->
            div
                []
                (List.map
                    (\item ->
                        div
                            [ style "opacity" "0.5", style "border-style" "dotted" ]
                            [ img [ src item.url, width 200, height 200 ] [] ]
                    )
                    innerList
                )
        )
        imagePaths



-- view


view : Model -> Html Msg
view model =
    div (styleFlexBox "column")
        [ div (styleFlexBox "row") (squares (split 4 model))

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
