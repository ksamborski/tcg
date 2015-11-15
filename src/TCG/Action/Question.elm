module TCG.Action.Question where

import Time exposing (Time)

type TcgQuestionAction
  = UpdateTimerSeconds Time
  | StopTimer
  | ShowAnswer

