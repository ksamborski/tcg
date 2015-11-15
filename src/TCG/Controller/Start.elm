module TCG.Controller.Start where

import Effects exposing (Effects)
import Array

import TCG.Model exposing (..)
import TCG.Action.Start exposing (..)
import TCG.Action exposing (..)

update : TcgStartAction -> TcgStateRecord -> (TcgState, Effects TcgAction)
update action s =
  case action of
    TeamsNumberChanged n ->
      let len = Array.length s.teams
      in (TcgState
           { s | teams <- if n > len
                           then Array.append s.teams
                                (Array.repeat (n - len) { teamName = ""
                                                        , teamScore = 0
                                                        })
                           else Array.slice 0 n s.teams
           }
         , Effects.none
         )
    TeamNameChanged i v ->
      let (Just team) = Array.get i s.teams
      in (TcgState {s | teams <- Array.set i { team | teamName <- v }
                                           s.teams
                   }
         , Effects.none)
    CategoryNumChanged i -> (TcgState {s | cat_num <- i}, Effects.none)
    QuestionsNumChanged i -> (TcgState {s | level_num <- i}, Effects.none)
