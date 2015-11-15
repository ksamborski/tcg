module TCG.View.Question where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import List
import Array
import Dict

import TCG.Action exposing (..)
import TCG.Action.Question exposing (..)
import TCG.Model exposing (TcgState(..), TcgStateRecord)
import TCG.Model.Question exposing (..)

view : Address TcgAction -> TcgState -> Html
view address (TcgState state) =
  let (Just (qcat,qlev)) = state.game.active_question
      (Just q) = Dict.get (qcat,qlev) state.game.questions
  in div [ class "card" ]
  [ div [ class "card-block" ]
    [ h4 [ class "card-title" ]
      [ text "Question"
      ]
    , h1 [ class "text-center" ] [ text q.question ]
    ]
  , if state.game.show_answer
      then render_answer address state q
      else render_timer address state
  ]

render_timer : Address TcgAction -> TcgStateRecord -> Html
render_timer address state =
  div [ class "card-footer" ]
  [ h4 [ class "card-title" ]
    [ text "Clock is ticking..." ]
  , h1 [ class "text-muted text-center", style [("font-size", "180px")] ]
    [ text (toString state.game.seconds_left)
    ]
  , if state.game.timer_stopped || state.game.seconds_left == 0
      then div [ class "text-center" ]
           [ button [ class "btn btn-lg btn-primary"
                    , onClick address (QuestionAction ShowAnswer)
                    ]
             [ text "Show answer" ]
           ]
      else div [ class "text-center" ]
           [ button [ class "btn btn-lg btn-primary"
                    , onClick address (QuestionAction StopTimer)
                    ]
             [ text "Stop the timer!" ]
           ]
  ]

render_answer : Address TcgAction -> TcgStateRecord -> Question -> Html
render_answer address state q =
  div [ class "card-footer" ]
  [ h4 [ class "card-title" ]
    [ text "And the answer is..." ]
  , iframe [ class "card"
           , style [("width", "100%"), ("height", "500px")]
           , src q.answer
           ] []
  , div [ class "text-center" ]
    [ div [ class "btn-group btn-group-lg" ]
      [ button ([ class "btn btn-success"
               , disabled (not state.game.timer_stopped)
               ] `List.append`
               (if state.game.timer_stopped
                then [onClick address (AddPoints True)]
                else []))
        [ text "I knew the answer!" ]
      , button [ class "btn btn-danger"
               , onClick address (AddPoints False)
               ]
        [ text "I lost everything..." ]
      ]
    ]
  ]
