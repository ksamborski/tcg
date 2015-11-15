module TCG.Translation.En where

import List
import Array exposing (Array)

import TCG.Model.Translation exposing (..)

translation : Translation
translation =
  { start =
    { welcome = "Welcome"
    , chooseParameters = "Please choose some of the game parameters."
    , numberOfTeams = "Number of teams"
    , numberOfCategories = "Number of categories"
    , numberOfQuestions = "Number of questions"
    , teamsName = \i -> "Team " ++ (toString i) ++ " name"
    , play = "Play!"
    , language = "Language"
    }
  , game =
    { chooseQuestion = "Choose your question"
    , teamTurn = \name -> "Team " ++ name ++ "'s turn"
    , teamScore = \name -> "Team " ++ name
    , scores = "Scores"
    }
  , question =
    { question = "Question"
    , clockTicking = "Clock is ticking..."
    , showAnswer = "Show answer"
    , stopTimer = "Stop the timer!"
    , answer = "And the answer is..."
    , answerOk = "I knew the answer!"
    , answerBad = "I lost everything..."
    }
  , endgame =
    { congratulations = "Congratulations"
    , playAgain = "Play again"
    , winners = \w ->
        if Array.length w > 1
          then "Teams: "
            ++ (List.foldl (++) ""
                  <| List.intersperse ", "
                  <| List.map (\t -> t.teamName)
                  <| Array.toList w)
               ++ " are the winners!"
          else
            let (Just t) = Array.get 0 w
            in "Team " ++ t.teamName ++ " is a winner!"
    }
  }
