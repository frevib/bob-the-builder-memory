import Browser
import Html exposing (Html, button, div, text, img)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, src, width, height)

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

images : List String
images =
  [
  "src/img/bob_the_builder_01.jpeg"
  , "src/img/bob_the_builder_01.jpeg"
  , "src/img/bob_the_builder_01.jpeg"
  ]

squares : List String -> List (Html msg)
squares imagePaths =
  List.map (\a -> img [src a, width 100, height 100] []) imagePaths
   |> List.repeat 2
   |> List.foldr (++) []


-- squareDiv : Model -> Html msg
-- squareDiv model =
--   div
--     [ style "background-color" "red"
--     , style "width" "100px"
--     , style "height" "100px"
--     ]
--     [ text ("w00t" ++ (String.fromInt model.opened)) ]


-- view
view : Model -> Html Msg
view model =
  div []
    (
    (squares images)
     |> List.repeat 2
     |> List.foldr (++) []
    )
