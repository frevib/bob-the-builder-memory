module Main exposing (Model, Msg(..), images1, init, main, split, squares, styleFlexBox, update, view)

import Array
import Browser
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (height, src, style, width)
import Html.Events exposing (onClick)
import List exposing (drop, take)

-- import Random exposing (Seed, generate)
-- import Random.List exposing (shuffle)


main =
    Browser.sandbox { init = init, update = update, view = view }


-- model


type alias Model =
    { openedImage : String, message : String }


init : Model
init =
    { openedImage = "", message = "" }



-- update


type Msg
    = Flip String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Flip openedImage ->
            if model.openedImage == "" then
                { openedImage = openedImage, message = "one more!" }

            else if openedImage == model.openedImage then
                { openedImage = "", message = "Bingo!" }

            else
                { openedImage = "", message = "too bad :(" }


images1 : List String
images1 =
    let
        images =
            [ "src/img/bob_the_builder_01.jpeg"
            , "src/img/dizzy.jpeg"
            , "src/img/rollie.jpeg"
            , "src/img/muck.jpeg"
            , "src/img/benny.jpeg"
            , "src/img/scoop.jpeg"
            ]
    in
    images ++ images


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


squares : List (List String) -> List (Html Msg)
squares imagePaths =
    List.map
        (\innerList ->
            div
                []
                (List.map
                    (\item ->
                         div
                            [ style "opacity" "0.5", style "border-style" "dotted" ]
                            [ img [ src item, width 200, height 200, onClick (Flip item) ] [] ]

                    )
                    innerList
                )
        )
        imagePaths

-- view


view : Model -> Html Msg
view model =
    div (styleFlexBox "column")
        [ div (styleFlexBox "row") (squares (split 4 images1))
        , div [] [ text model.message ]
        , div [] []
        ]
