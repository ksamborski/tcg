module TCG.Model where

import Html exposing (Html)
import Effects exposing (Effects)
import Array exposing (Array)
import Signal exposing (..)

import TCG.Action exposing (..)
import TCG.Model.Team exposing (..)
import TCG.Model.InputData exposing (..)
import TCG.Model.GameState exposing (..)

type TcgState = TcgState TcgStateRecord

type alias TcgStateRecord =
  { teams : Array Team
  , cat_num : Int
  , level_num : Int
  , data : InputData
  , game : GameState
  , activeView : Address TcgAction -> TcgState -> Html
  }
