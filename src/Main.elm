module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (Html, button, div, main_, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { cursors : Int
    , points : Float
    }


type alias Points =
    Float



-- antalet cursors
-- poängen


init : () -> ( Model, Cmd Msg )
init _ =
    ( { cursors = 0
      , points = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Increment
    | Reset
    | ClickedBuyCursor
    | Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | points = model.points + pointsPerClick model }, Cmd.none )

        Reset ->
            init ()

        ClickedBuyCursor ->
            ( if model.points < 10 then
                model

              else
                { model
                    | cursors = model.cursors + 1
                    , points = model.points - 10
                }
            , Cmd.none
            )

        Tick ->
            ( { model | points = model.points + (toFloat model.cursors * 0.1) }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "left-sidebar" ]
            [ div [ class "points" ] [ text (String.fromFloat (roundPoints model.points)) ]
            , button [ onClick Increment, class "cookie" ] [ text "🍪" ]
            ]
        , main_ [ class "main" ] [ text "" ]
        , div [ class "right-sidebar" ]
            [ button [ onClick Reset ] [ text "Reset" ]
            , button [ onClick ClickedBuyCursor ]
                [ text "Cursor ("
                , text (String.fromInt model.cursors)
                , text ")"
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every 10000 (\_ -> Tick)
        ]


roundPoints : Float -> Float
roundPoints x =
    toFloat (round (x * 10)) / 10


initPointsPerClick : Points
initPointsPerClick =
    1


pointsPerClick : Model -> Points
pointsPerClick model =
    case model.cursors of
        0 ->
            initPointsPerClick

        _ ->
            initPointsPerClick + (toFloat model.cursors / 10 * initPointsPerClick)
