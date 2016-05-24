module Hex exposing (darken, lighten)

import String
import Char
import List
import Color

cutHash : String -> String
cutHash hexColor =
  if String.startsWith "#" hexColor
    then String.dropLeft 1 hexColor
      else hexColor


fixLength : String -> String
fixLength hexColor =
  case String.length hexColor of
    3 -> hexColor
      |> String.toList
      |> List.map (\n -> String.fromChar n)
      |> List.map (\n -> String.repeat 2 n)
      |> String.join ""
    6 -> hexColor
    default -> "FFFFFF"


getHexInt : Char -> Int
getHexInt char =
  if Char.isDigit char
    then getIntFromChar char
      else getIntFromHexChar char


getIntFromHexChar : Char -> Int
getIntFromHexChar char =
  case Char.toLower char of
    'a' -> 10
    'b' -> 11
    'c' -> 12
    'd' -> 13
    'e' -> 14
    'f' -> 15
    default -> 0


getIntFromChar : Char -> Int
getIntFromChar char =
  case String.toInt (String.fromChar char) of
    Ok value ->
      value
    Err error ->
      0


getDecimalIntFromHexString : String -> Int
getDecimalIntFromHexString str =
  str
    |> String.toList
    |> List.map (\n -> getHexInt n)
    |> List.reverse
    |> List.indexedMap (,)
    |> List.map (\(index, n) -> n * 16^index )
    |> List.sum


getR : String -> Int
getR color =
  color
    |> String.slice 0 2
    |> getDecimalIntFromHexString


getG : String -> Int
getG color =
  color
    |> String.slice 2 4
    |> getDecimalIntFromHexString


getB : String -> Int
getB color =
  color
    |> String.slice 4 6
    |> getDecimalIntFromHexString


toRgb : String -> Color.Color
toRgb hexColor =
  let cleanColor = hexColor
    |> cutHash
    |> fixLength
  in
    Color.rgb (getR cleanColor) (getG cleanColor) (getB cleanColor)


decimalToHexString : Int -> String
decimalToHexString decimal =
  let remainder = decimal % 16
      quotient = decimal // 16
  in
    if quotient > 16 then
       (decimalToHexString quotient) ++ (hexToString remainder)
    else
       (hexToString quotient) ++ (hexToString remainder)


hexToString : Int -> String
hexToString decimal =
  if decimal <= 9
    then toString decimal
    else case decimal of
      10 -> "A"
      11 -> "B"
      12 -> "C"
      13 -> "D"
      14 -> "E"
      15 -> "F"
      default -> ""


makeDarker : Float -> Color.Color -> Color.Color
makeDarker percentage color =
  let hsl = Color.toHsl color
      lightness = adjustLightness color percentage (-)
  in
    Color.hsla hsl.hue hsl.saturation lightness hsl.alpha


makeLighter : Float -> Color.Color -> Color.Color
makeLighter percentage color =
  let hsl = Color.toHsl color
      lightness = adjustLightness color percentage (+)
  in
    Color.hsla hsl.hue hsl.saturation lightness hsl.alpha


adjustLightness : Color.Color -> Float -> (Float -> Float -> number) -> Float
adjustLightness color percentage adjust =
  let hslValues = Color.toHsl color
      pc = percentageToFloat percentage
  in
    hslValues
      |> .lightness
      |> adjust pc
      |> abs


percentageToFloat : Float -> Float
percentageToFloat percentage =
  percentage / 100


toCssHexString : Color.Color -> String
toCssHexString color =
  let rgb = Color.toRgb color
      red = decimalToHexString rgb.red
      green = decimalToHexString rgb.green
      blue = decimalToHexString rgb.blue
  in
    "#" ++ red ++ green ++ blue


darken : String -> Float -> String
darken cssHexColorString amount =
  cssHexColorString
    |> toRgb
    |> makeDarker amount
    |> toCssHexString


lighten : String -> Float -> String
lighten cssHexColorString amount =
  cssHexColorString
    |> toRgb
    |> makeLighter amount
    |> toCssHexString
