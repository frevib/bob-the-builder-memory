import Browser
import Html exposing (Html, button, div, text, img)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, src, width, height)
import Array
-- import Random exposing (Seed, generate)
-- import Random.List exposing (shuffle)

main =
  Browser.sandbox { init = init, update = update, view = view }

-- model
type alias Model =
  { openedImage: String, message: String }

init : Model
init = { openedImage = "", message = "" }

-- update
type Msg = Flip String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Flip openedImage ->
      if model.openedImage == "" then
        { openedImage = openedImage, message = "one more!" }
      else
        if openedImage == model.openedImage then
          { openedImage = "", message = "Bingo!" }
        else
          { openedImage = "", message = "too bad :(" }


images1 : List String
images1 =
  [
  "src/img/bob_the_builder_01.jpeg"
  , "src/img/dizzy.jpeg"
  , "src/img/rollie.jpeg"
  , "src/img/muck.jpeg"
  , "src/img/benny.jpeg"
  , "src/img/scoop.jpeg"
  ]

images2 : List String
images2 =
    [
    "src/img/bob_the_builder_01.jpeg"
    , "src/img/dizzy.jpeg"
    , "src/img/rollie.jpeg"
    , "src/img/muck.jpeg"
    , "src/img/benny.jpeg"
    , "src/img/scoop.jpeg"
    ]

styleFlexBox : String -> List (Html.Attribute Msg)
styleFlexBox direction =
    [
    style "display" "flex"
    , style "flex-direction" direction
    ]



squares : List String -> List (Html Msg)
squares imagePaths =
  List.map (\item ->
    [ div [ style "opacity" "0.5", style "border-style" "dotted" ] [ img [src item, width 200, height 200, onClick (Flip item) ] [] ] ]
    ) imagePaths
  |> List.concat

-- view
view : Model -> Html Msg
view model =
  div (styleFlexBox "column")
  [ div (styleFlexBox "row") (squares images1)
  , div (styleFlexBox "row") (squares images2)
  , div [] [ text (model.message)]
  ]
