import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)

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

squareDiv : Model -> Html msg
squareDiv model =
  div
    [ style "background-color" "red"
    , style "width" "100px"
    , style "height" "100px"
    ]
    [ text ("w00t" ++ (String.fromInt model.opened)) ]


-- view
view : Model -> Html Msg
view model =
  div []
    [
    -- [ button [ onClick Decrement ] [ text "-"]
    -- div [] [ text (String.fromInt  model ) ]
    -- , div [ onClick (Flip 4) ] [ text "other text" ]
    squareDiv model
    , button [ onClick (Flip 3)] [ text "++++"]
    ]
