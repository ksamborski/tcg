module TCG.View.Question where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import List
import Array

import TCG.Action exposing (TcgAction)
import TCG.Model exposing (TcgState(..), TcgStateRecord)
import TCG.Model.Question exposing (..)

view : Address TcgAction -> TcgState -> Html
view address (TcgState state) =
  let (Just (qcat, qlev)) = state.game.active_question
      (q::_) = List.filter (\q -> q.category == qcat && q.level == qlev)
               state.game.questions
  in div [ class "card" ]
  [ div [ class "card-block" ]
    [ h4 [ class "card-title" ]
      [ text q.question
      ]
    ]
  ]
