module TCG.Translation.Pl where

import List
import Array exposing (Array)

import TCG.Model.Translation exposing (..)

translation : Translation
translation =
  { start =
    { welcome = "Witamy"
    , chooseParameters = "Wybierz parametry gry."
    , numberOfTeams = "Liczba drużyn"
    , numberOfCategories = "Liczba kategorii"
    , numberOfQuestions = "Liczba pytań w kategorii"
    , teamsName = \i -> "Nazwa drużyny " ++ (toString i)
    , play = "Graj!"
    , language = "Język gry"
    }
  , game =
    { chooseQuestion = "Wybierz pytanie"
    , teamTurn = \name -> "Ruch drużyny " ++ name
    , teamScore = \name -> "Drużyna " ++ name
    , scores = "Punktacja"
    }
  , question =
    { question = "Treść pytania"
    , clockTicking = "Odliczanie..."
    , showAnswer = "Pokaż odpowiedź"
    , stopTimer = "Zatrzymaj zegar!"
    , answer = "Odpowiedź to..."
    , answerOk = "Wiedziałem!"
    , answerBad = "Wszystko stracone..."
    }
  , endgame =
    { congratulations = "Gratulacje"
    , playAgain = "Zagraj ponownie"
    , winners = \w ->
        if Array.length w > 1
          then "Wygrały drużyny "
            ++ (List.foldl (++) ""
                  <| List.intersperse ", "
                  <| List.map (\t -> t.teamName)
                  <| Array.toList w)
               ++ "!"
          else
            let (Just t) = Array.get 0 w
            in "Wygrała drużyna " ++ t.teamName ++ "!"
    }
  }
