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
  { opened: Int }

init : Model
init = { opened = 0 }

-- update
type Msg = Flip Int

update : Msg -> Model -> Model
update msg model =
  case msg of
    Flip boxNumber ->
      if model.opened > 3 then
        { opened = 0 }
      else
        { model | opened = boxNumber + model.opened }

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


squares : List String -> List (Html msg)
squares imagePaths =
  List.map (\item -> [ img [src item, width 200, height 200] [] ]) imagePaths
  |> List.concat

-- view
view : Model -> Html Msg
view model =
  div [ style "display" "flex", style "flex-direction" "column"]
  [ div [ style "display" "flex", style "flex-direction" "row" ] (squares images1)
  , div [ style "display" "flex", style "flex-direction" "row" ] (squares images2)
  ]
