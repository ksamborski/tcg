module TCG.Model.InputData where

type alias InputQuestion =
  { category : String
  , level : Int
  , question : String
  , answer : String
  }

type alias InputData =
  { categories : List String
  , levels : List Int
  , questions : List InputQuestion
  }
