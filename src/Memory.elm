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
    { id : Int, url : String, opened : Bool, found : Bool }


type alias Model =
    { tiles : List ImageRecord
    , selectedImageUrl : String
    }


type Msg
    = --  Flip String
      Reset
    | ShuffledDone (List ImageRecord)
    | SelectSquare ImageRecord


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
            ImageRecord index imageUrl False False
        )
        imageRecords1



-- init


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { tiles = imageRecords, selectedImageUrl = "" }
    , Random.generate ShuffledDone (Random.List.shuffle imageRecords)
    )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShuffledDone shuffledList ->
            ( { tiles = shuffledList, selectedImageUrl = "" }, Cmd.none )

        Reset ->
            ( model, Random.generate ShuffledDone (Random.List.shuffle imageRecords) )

        SelectSquare imageRecord_ ->
            if model.selectedImageUrl == imageRecord_.url then
                ( { tiles = setFound model.tiles model.selectedImageUrl, selectedImageUrl = "" }, Cmd.none )

            else if model.selectedImageUrl == "" then
                ( { tiles = flipTile model.tiles imageRecord_.id, selectedImageUrl = imageRecord_.url }, Cmd.none )

            else
                ( { tiles = closeOpened model.tiles, selectedImageUrl = "" }, Cmd.none )


getSelectedUrl imageRecords1 id =
    List.map
        (\item ->
            if item.id == id then
                item.url

            else
                ""
        )
        imageRecords1
        |> String.concat


setFound imageRecords3 selectedImageUrl2 =
    List.map
        (\item ->
            if item.url == selectedImageUrl2 then
                { item | found = True }

            else
                item
        )
        imageRecords3


flipTile imageRecords2 id1 =
    List.map
        (\item ->
            if item.id == id1 then
                { item | opened = True }

            else
                item
        )
        imageRecords2


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



-- tileStateAttributes item =
--     if item.opene


styleFlipped item =
    if item.found then
        [ style "opacity" "0.7" ]

    else if item.opened then
        [ style "opacity" "1.0" ]

    else
        [ style "opacity" "0.3", onClick (SelectSquare item) ]


squares : List (List ImageRecord) -> List (Html Msg)
squares images =
    List.map
        (\innerList ->
            div
                []
                (List.map
                    (\item ->
                        div
                            (styleFlipped item
                                ++ [ style "border-style" "dotted" ]
                            )
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
        [ div (styleFlexBox "row") (squares (split 3 model.tiles))
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
