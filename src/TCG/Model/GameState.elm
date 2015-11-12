module TCG.Model.GameState where

import TCG.Model.Question exposing (..)

type alias GameState =
  { categories : List String
  , levels : List Int
  , questions : List Question
  , active_team : Int
  , active_question : Maybe (String, Int)
  , seconds_left : Int
  , timer_stopped : Bool
  , show_answer : Bool
  }
