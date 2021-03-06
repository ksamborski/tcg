module TCG.Action where

import Signal exposing (..)
import String exposing (toInt)
import Maybe exposing (withDefault)
import Result exposing (toMaybe)
import Time exposing (Time)

import TCG.Model.InputData exposing (..)
import TCG.Model.Translation exposing (..)
import TCG.Action.Start exposing (..)
import TCG.Action.Question exposing (..)

type TcgAction
  = NoOp
  | Input InputData
  | StartAction TcgStartAction
  | QuestionAction TcgQuestionAction
  | StartGame
  | Randomize Time
  | ShowQuestion String Int
  | AddPoints Bool
  | Restart
  | ChangeLanguage Language

intMessage : Address TcgAction -> (Int -> TcgAction) -> Int -> String -> Message
intMessage address a d v =
  message address <| a <| withDefault d <| toMaybe <| toInt v
