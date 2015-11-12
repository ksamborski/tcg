module Main where

import Effects exposing (..)
import StartApp
import Task
import Array exposing (..)
import Time exposing (..)

import TCG.Model exposing (..)
import TCG.Model.InputData exposing (..)
import TCG.View exposing (..)
import TCG.View.Start as Start
import TCG.Controller exposing (..)
import TCG.Action exposing (..)
import TCG.Action.Question exposing (..)

app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ Signal.map Input input
               , Signal.map (always (QuestionAction UpdateTimerSeconds))
                   <| every second
               ]
    }

init : (TcgState, Effects TcgAction)
init =
  ( TcgState
    { teams = Array.fromList
      [ { teamName = "", teamScore = 0 }
      , { teamName = "", teamScore = 0 }
      ]
    , data = { categories = [], levels = [], questions = [] }
    , cat_num = 1
    , level_num = 1
    , activeView = Start.view
    , game = { categories = []
             , levels = []
             , questions = []
             , active_team = 0
             , active_question = Nothing
             , seconds_left = 30
             , timer_stopped = False
             , show_answer = False
             }
    }
  , Effects.none
  )

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

port input : Signal InputData
