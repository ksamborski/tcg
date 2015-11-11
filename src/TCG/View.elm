module TCG.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import List

import TCG.Model exposing (..)
import TCG.Action exposing (TcgAction)

view : Address TcgAction -> TcgState -> Html
view address state =
  let (TcgState st) = state
  in st.activeView address state
