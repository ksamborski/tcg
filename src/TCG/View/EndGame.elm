module TCG.View.EndGame where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import List
import Array exposing (Array)

import TCG.Model exposing (TcgState(..), TcgStateRecord)
import TCG.Action exposing (..)

view : Address TcgAction -> TcgState -> Html
view address (TcgState state) =
  let (Just maxScore) = (List.maximum <| List.map (\t -> t.teamScore) <| Array.toList state.teams)
      winners = Array.filter (\t -> t.teamScore == maxScore) state.teams
  in div [ class "row", style [ ("margin-top", "50px") ] ]
     [ div [ class "col-md-8 col-md-offset-2" ]
       [ div [ class "card card-block card-inverse card-success"]
         [ h4 [ class "card-title" ]
              [ text state.tr.endgame.congratulations ]
         , p [ class "card-text" ]
             [ text (state.tr.endgame.winners winners) ]
         , div [ class "card-footer text-center" ]
           [ button
             [ class "btn btn-warning"
             , onClick address Restart
             ]
             [ text state.tr.endgame.playAgain ]
           ]
         ]
       ]
     ]
