module TCG.Action.Start where

type TcgStartAction
  = TeamsNumberChanged Int
  | TeamNameChanged Int String
  | CategoryNumChanged Int
  | QuestionsNumChanged Int

