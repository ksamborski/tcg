module TCG.View.Game where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import List
import Array
import Dict

import TCG.Model exposing (TcgState(..), TcgStateRecord)
import TCG.Model.Question exposing (..)
import TCG.Model.Team exposing (..)
import TCG.Action exposing (..)

view : Address TcgAction -> TcgState -> Html
view address (TcgState state) =
  div [ class "card" ]
  [ div [ class "card-block" ]
    [ h4 [ class "card-title" ]
      [ text "Choose your question" ]
    , p [ class "card-text" ]
      [ text "Team "
      , text (
          let (Just t) = Array.get state.game.active_team state.teams
          in t.teamName
        )
      , text "'s turn"
      ]
    ]
  , div [ class "card-block" ]
    [ table [ class "table" ]
      [ thead [ class "thead-inverse" ]
        [ tr [] (List.map renderCategory state.game.categories) ]
      , tbody []
        (List.map (renderRow address state) state.game.levels)
      ]
    ]
  , div [ class "card-footer" ]
    [ h4 [ class "card-title" ] [ text "Scores" ]
    , table [ class "table table-bordered" ]
      [ tbody []
        [ tr []
          (List.map renderScore <| Array.toList state.teams)
        ]
      ]
    ]
  ]

renderScore : Team -> Html
renderScore t =
  td [ class "text-center" ]
  [ b []
    [ text "Team ", text t.teamName ]
  , text ": "
  , text (toString t.teamScore)
  ]

renderCategory : String -> Html
renderCategory cat = th [ class "text-center" ] [ text cat ]

renderRow : Address TcgAction -> TcgStateRecord -> Int -> Html
renderRow address state level =
  tr []
    <| List.map (\q -> renderQuestion address state q)
    <| List.filter (\q -> q.level == level)
    <| Dict.values state.game.questions

renderQuestion : Address TcgAction -> TcgStateRecord -> Question -> Html
renderQuestion address state q =
  td []
  <| if q.answered
      then [ button [ class "btn btn-danger"
                    , style [("width", "100%")]
                    , disabled True
                    ]
             [ text (toString q.level)
             ]
           ]
      else [ button [ class "btn btn-primary-outline"
                    , style [("width", "100%")]
                    , onClick address (ShowQuestion q.category q.level)
                    ]
             [ text (toString q.level)
             ]
           ]
