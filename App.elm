import Hex exposing (darken, lighten)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

square color =
  let
    styles = style
      [ ("width", "40px")
      , ("height", "40px")
      , ("background", color)
      ]
  in
    div [ styles ] [ text color]


main =
  div []
    [ (square (darken "#00f" 0 ))
    , (square (darken "#00f" 30))
    , (square (lighten "#f00" 0))
    , (square (lighten "#f00" 30))
    ]
