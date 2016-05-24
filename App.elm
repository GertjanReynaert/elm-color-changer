import Hex exposing (darken, lighten)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import String


square color =
  let
    styles = style
      [ ("width", "60px")
      , ("height", "60px")
      , ("margin", "20px")
      , ("padding", "20px")
      , ("border-radius", "4px")
      , ("color", "white")
      , ("font-family", "sans-serif")
      , ("font-weight", "")
      , ("background", color)
      ]
  in
    div [ styles ] [ text (String.toUpper color)]


main =
  div []
    [ (square (lighten "#f00" 30))
    , (square "#f00")
    , (square (darken "#f00" 30))
    ]
