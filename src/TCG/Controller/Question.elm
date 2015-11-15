module TCG.Controller.Question where

import Effects exposing (Effects)
import Time exposing (..)

import TCG.Model exposing (..)
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
    UpdateTimerSeconds t ->
      case sgame.last_tick of
        Nothing -> ( TcgState { s | game <- { sgame | last_tick <- Just t } }
                   , Effects.tick (QuestionAction << UpdateTimerSeconds)
                   )
        Just t2 -> case (s.game.active_question, s.game.timer_stopped) of
          (Just q, False) ->
            let tdiff = floor <| inSeconds t - inSeconds t2
            in if tdiff > 0
                then ( TcgState {s | game <- { sgame | seconds_left <- max (sgame.seconds_left - tdiff) 0
                                             , last_tick <- Just t
                                             }
                                }
                     , if sgame.seconds_left - tdiff > 0
                         then Effects.tick (QuestionAction << UpdateTimerSeconds)
                         else Effects.none)
                else (TcgState s, Effects.tick (QuestionAction << UpdateTimerSeconds))
          _ -> (TcgState s, Effects.none)

