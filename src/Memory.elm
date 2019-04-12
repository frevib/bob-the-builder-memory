module Main exposing (Model, Msg(..), imageRecords, init, main, split, squares, styleFlexBox, update, view)

import Array exposing (Array, indexedMap)
import Browser
import Browser.Events exposing (onKeyDown)
import Delay exposing (..)
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (height, src, style, width)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import List exposing (drop, take)
import Random
import Random.Array
import Random.List


type alias Flags =
    ()


type alias ImageRecord =
    { id : Int, url : String, opened : Bool, found : Bool }


type alias Model =
    { tiles : List ImageRecord
    , selectedImageUrl : String
    , tilesClickable : Bool
    }


type Msg
    = Reset
    | ShuffledDone (List ImageRecord)
    | SelectSquare ImageRecord
    | FirstMessage ImageRecord
    | OpenSecondTile ImageRecord
    | CloseTile ImageRecord
    | CloseOpened


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
        |> generateImageRecords


generateImageRecords : List String -> List ImageRecord
generateImageRecords imageRecords1 =
    List.indexedMap
        (\index imageUrl ->
            ImageRecord index imageUrl False False
        )
        imageRecords1



-- init


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { tiles = imageRecords, selectedImageUrl = "", tilesClickable = True }
    , Random.generate ShuffledDone (Random.List.shuffle imageRecords)
    )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShuffledDone shuffledList ->
            ( { tiles = shuffledList, selectedImageUrl = "", tilesClickable = True }, Cmd.none )

        Reset ->
            ( model, Random.generate ShuffledDone (Random.List.shuffle imageRecords) )

        FirstMessage imageRecord_ ->
            ( model
            , Cmd.batch
                [ Delay.sequence
                    [ ( 0, Millisecond, SelectSquare imageRecord_ )
                    , ( 2000, Millisecond, CloseTile imageRecord_ )
                    ]
                ]
            )

        CloseTile imageRecord_ ->
            ( { tiles = closeTile model.tiles imageRecord_.id, selectedImageUrl = "", tilesClickable = True }, Cmd.none )

        OpenSecondTile imageRecord_ ->
            ( { tiles = openTile model.tiles imageRecord_.id, selectedImageUrl = "", tilesClickable = False }, Cmd.none )

        CloseOpened ->
            ( { tiles = closeOpened model.tiles, selectedImageUrl = "", tilesClickable = True }, Cmd.none )

        SelectSquare imageRecord_ ->
            if model.selectedImageUrl == imageRecord_.url then
                ( { tiles = setFound model.tiles model.selectedImageUrl, selectedImageUrl = "", tilesClickable = True }, Cmd.none )

            else if model.selectedImageUrl == "" then
                ( { tiles = openTile model.tiles imageRecord_.id, selectedImageUrl = imageRecord_.url, tilesClickable = True }, Cmd.none )

            else
                ( model
                , Cmd.batch
                    [ Delay.sequence
                        [ ( 0, Millisecond, OpenSecondTile imageRecord_ )
                        , ( 2000, Millisecond, CloseOpened )
                        ]
                    ]
                )


setFound imageRecords3 selectedImageUrl2 =
    List.map
        (\item ->
            if item.url == selectedImageUrl2 then
                { item | found = True }

            else
                item
        )
        imageRecords3


openTile imageRecords2 id1 =
    List.map
        (\item ->
            if item.id == id1 then
                { item | opened = True }

            else
                item
        )
        imageRecords2


closeTile imageRecords7 id7 =
    List.map
        (\item ->
            if item.id == id7 then
                { item | opened = False }

            else
                item
        )
        imageRecords7


closeOpened imageRecords5 =
    List.map
        (\item ->
            { item | opened = False }
        )
        imageRecords5


split : Int -> List a -> List (List a)
split i list =
    case take i list of
        [] ->
            []

        listHead ->
            listHead :: split i (drop i list)


styleFlipped item tilesClickable =
    if item.found then
        [ style "opacity" "1" ]

    else if item.opened then
        [ style "opacity" "0.5" ]

    else if tilesClickable then
        [ style "opacity" "0", onClick (SelectSquare item)  ]

    else
        [ style "opacity" "0" ]


squares : List (List ImageRecord) -> Model -> List (Html Msg)
squares images model =
    List.map
        (\innerList ->
            div
                []
                (List.map
                    (\item ->
                        div
                            [ style "border-style" "dotted" ]
                            [ div
                                (styleFlipped item model.tilesClickable)
                                [ img [ src item.url, width 200, height 200 ] [] ]
                            ]
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
        [ div (styleFlexBox "row") (squares (split 3 model.tiles) model)
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
