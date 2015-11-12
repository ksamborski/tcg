module TCG.Action.Question where

type TcgQuestionAction
  = UpdateTimerSeconds
  | StopTimer
  | ShowAnswer
  | GoodAnswer
  | BadAnswer

