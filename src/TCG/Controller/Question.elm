module TCG.Controller.Question where

import Effects exposing (Effects)

import TCG.Model exposing (..)
import TCG.Model.GameState exposing (..)
import TCG.Action exposing (..)
import TCG.Action.Question exposing (..)

update : TcgQuestionAction -> TcgStateRecord -> (TcgState, Effects TcgAction)
update action s =
  let sgame = s.game
  in case action of
    StopTimer -> ( TcgState { s | game <- { sgame | timer_stopped <- True } }
                 , Effects.none)
    ShowAnswer -> ( TcgState { s | game <- { sgame | show_answer <- True } }
                  , Effects.none)
    UpdateTimerSeconds -> case (s.game.active_question, s.game.timer_stopped) of
      (Just q, False) ->
        ( TcgState {s | game <- { sgame | seconds_left <- max (sgame.seconds_left - 1) 0
                                   }
                      }
           , Effects.none)
      _ -> (TcgState s, Effects.none)

