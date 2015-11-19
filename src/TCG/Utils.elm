module TCG.Utils where

import Maybe

fromJust : Maybe a -> a
fromJust ma = case ma of
  Just a -> a
  Nothing -> Debug.crash "fromJust got nothing."
