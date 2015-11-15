module TCG.Model.Translation where

import Array exposing (Array)
import TCG.Model.Team exposing (Team)

type Language = En | Pl

type alias Translation =
  { start : { welcome : String
            , chooseParameters : String
            , numberOfTeams : String
            , numberOfCategories : String
            , numberOfQuestions : String
            , teamsName : (Int -> String)
            , play : String
            , language : String
            }
  , game : { chooseQuestion : String
           , teamTurn : (String -> String)
           , teamScore : (String -> String)
           , scores : String
           }
  , question : { question : String
               , clockTicking : String
               , showAnswer : String
               , stopTimer : String
               , answer : String
               , answerOk : String
               , answerBad : String
               }
  , endgame : { congratulations : String
              , playAgain : String
              , winners : (Array Team -> String)
              }
  }

langToInt : Language -> Int
langToInt l = case l of
  En -> 0
  Pl -> 1

intToLang : Int -> Language
intToLang i = case i of
  0 -> En
  1 -> Pl
