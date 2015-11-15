module TCG.Model.GameState where

import TCG.Model.Question exposing (..)
import Time exposing (Time)
import Dict exposing (Dict)

type alias GameState =
  { categories : List String
  , levels : List Int
  , questions : Dict (String, Int) Question
  , active_team : Int
  , active_question : Maybe (String, Int)
  , last_tick : Maybe Time
  , seconds_left : Int
  , timer_stopped : Bool
  , show_answer : Bool
  }
