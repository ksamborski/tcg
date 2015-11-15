module TCG.View.Start (view) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import Array
import List

import TCG.Model exposing (TcgState(..))
import TCG.Model.Translation exposing (..)
import TCG.Model.Team exposing (..)
import TCG.Action exposing (..)
import TCG.Action.Start exposing (..)

view : Address TcgAction -> TcgState -> Html
view address (TcgState state) =
  div [ class "row", style [ ("margin-top", "50px") ] ]
  [ div [ class "col-md-8 col-md-offset-2" ]
    [ div [ class "card card-block card-inverse card-success"]
      [ h4 [ class "card-title" ] [ text state.tr.start.welcome ]
      , p [ class "card-text" ] [ text state.tr.start.chooseParameters ]
      , Html.form []
        [ div [ class "form-group row" ]
           [ label [ class "col-md-4 form-control-label" ]
             [ text state.tr.start.language ]
           , div [ class "col-md-8" ]
             [ select
               [ class "form-control"
               , on "change" targetValue
                 (intMessage address (ChangeLanguage << intToLang) 0)
               ]
               [ option [ value (toString <| langToInt En)
                        , selected (state.active_tr == En)
                        ]
                        [ text "En" ]
               , option [ value (toString <| langToInt Pl)
                        , selected (state.active_tr == Pl)
                        ]
                        [ text "Pl" ]
               ]
             ]
           ]
        , div [ class "form-group row" ]
           [ label [ class "col-md-4 form-control-label" ]
             [ text state.tr.start.numberOfTeams ]
           , div [ class "col-md-8" ]
             [ input [ type' "number"
                     , class "form-control"
                     , Html.Attributes.min "2"
                     , value (toString <| Array.length state.teams)
                     , on "change" targetValue
                       (intMessage address
                         (StartAction << TeamsNumberChanged)
                         (Array.length state.teams))
                     ]
               []
             ]
           ]
        , div [ class "form-group row" ]
          [ label [ class "col-md-4 form-control-label" ]
            [ text state.tr.start.numberOfCategories ]
          , div [ class "col-md-8" ]
            [ select
              [ class "form-control"
              , on "change" targetValue
                (intMessage address
                  (StartAction << CategoryNumChanged)
                  state.cat_num)
              ]
              (List.map (\i -> option [ value (toString i), selected (i == state.cat_num) ]
                                      [ text (toString i) ])
                        [1..(List.length state.data.categories)])
            ]
          ]
        , div [ class "form-group row" ]
          [ label [ class "col-md-4 form-control-label" ]
            [ text state.tr.start.numberOfQuestions ]
          , div [ class "col-md-8" ]
            [ select
              [ class "form-control"
              , on "change" targetValue
                (intMessage address
                  (StartAction << QuestionsNumChanged)
                  state.level_num)
              ]
              (List.map (\i -> option [ value (toString i), selected (i == state.level_num) ]
                                      [ text (toString i) ])
                        [1..(List.length state.data.levels)])
            ]
          ]
        ]
      , div [ class "card-footer", style [ ("color", "#333") ] ]
        (List.map (renderTeam address state.tr)
          <| Array.toIndexedList state.teams)
      , button
        [ class "pull-right btn btn-warning"
        , style [("margin-top", "20px")]
        , onClick address StartGame
        ]
        [ text state.tr.start.play ]
      , div [ style [ ("clear", "both") ] ] []
      ]
    ]
  ]

renderTeam : Address TcgAction -> Translation -> (Int, Team) -> Html
renderTeam a tr (i, t) =
  div [ class "form-group row" ]
  [ label [ class "col-md-4 form-control-label" ]
    [ text <| tr.start.teamsName (i + 1)
    ]
  , div [ class "col-md-8" ]
    [ input [ type' "text"
            , class "form-control"
            , value t.teamName
            , on "change" targetValue
              (\v -> message a (StartAction <| TeamNameChanged i v))
            ]
      []
    ]
  ]
