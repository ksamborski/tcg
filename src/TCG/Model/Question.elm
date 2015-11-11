module TCG.Model.Question where

type alias Question =
  { category : String
  , level : Int
  , question : String
  , answer : String
  , answered : Bool
  }
