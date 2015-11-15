module TCG.Controller where

import Effects exposing (Effects)
import Time exposing (..)
import Random exposing (..)
import List
import Array exposing (Array)
import Trampoline exposing (..)
import Dict
import Maybe exposing (withDefault)

import TCG.Action exposing (..)
import TCG.Action.Question exposing (..)
import TCG.Controller.Start as Start
import TCG.Controller.Question as Question
import TCG.Model.GameState exposing (..)
import TCG.Model.Question exposing (..)
import TCG.Model.InputData exposing (..)
import TCG.Model.Translation as Translation
import TCG.Model exposing (..)
import TCG.View.Start as Start
import TCG.View.Game as Game
import TCG.View.EndGame as EndGame
import TCG.View.Question as Question

import TCG.Translation.En as En
import TCG.Translation.Pl as Pl

update : TcgAction -> TcgState -> (TcgState, Effects TcgAction)
update action (TcgState s) =
  case action of
    ChangeLanguage lang ->
      ( TcgState { s | active_tr <- lang
                     , tr <- case lang of
                              Translation.En -> En.translation
                              Translation.Pl -> Pl.translation
                 }
      , Effects.none)
    Input d -> (TcgState { s | data <- d }, Effects.none)
    StartAction a -> Start.update a s
    StartGame -> (TcgState s, Effects.tick Randomize)
    QuestionAction a -> Question.update a s
    Randomize t ->
      (TcgState { s | activeView <- Game.view
                    , game <- randomize s
                            <| initialSeed <| round <| inMilliseconds t
                }
      , Effects.none)
    ShowQuestion cat lev ->
      let sgame = s.game
      in ( TcgState { s | game <- { sgame | active_question <- Just (cat, lev)
                                          , seconds_left <- 30
                                          , timer_stopped <- False
                                          , last_tick <- Nothing
                                          , show_answer <- False
                                  }
                        , activeView <- Question.view
                    }
         , Effects.tick (QuestionAction << UpdateTimerSeconds))
    Restart -> ( TcgState { s | activeView <- Start.view
                              , teams <- Array.map (\t -> {t | teamScore <- 0}) s.teams
                          }
               , Effects.none)
    AddPoints answered ->
      let sgame = s.game
          (Just (qcat,qlev)) = s.game.active_question
          (Just q) = Dict.get (qcat,qlev) sgame.questions
          (Just ateam) = Array.get sgame.active_team s.teams
          updatedQuestions = Dict.update (qcat,qlev)
                                         (\(Just q') -> Just { q' | answered <- True })
                                         sgame.questions
      in ( TcgState { s | game <- { sgame | active_question <- Nothing
                                          , active_team <-
                                            if sgame.active_team + 1
                                                >= Array.length s.teams
                                              then 0
                                              else sgame.active_team + 1
                                          , questions <- updatedQuestions
                                  }
                        , teams <- Array.set sgame.active_team
                            {ateam | teamScore <- ateam.teamScore + (if answered then q.level else 0)}
                            s.teams
                        , activeView <-
                          if Dict.isEmpty
                             <| Dict.filter (\_ v -> not (v.answered))
                                            updatedQuestions
                            then EndGame.view
                            else Game.view
                    }
         , Effects.none)
    _ -> (TcgState s, Effects.none)

randomize : TcgStateRecord -> Seed -> GameState
randomize state seed =
  let cats = trampoline
          <| randomSeq seed state.cat_num allCats []
      allCats = Array.fromList state.data.categories
      levs = List.sort
          <| trampoline
          <| randomSeq seed state.level_num allLevs []
      allLevs = Array.fromList state.data.levels
  in { categories = cats
     , levels = levs
     , questions = Dict.fromList
        <| List.map (\q -> ((q.category, q.level),q))
        <| randomQuestions seed cats levs state.data.questions
     , active_team = 0
     , active_question = Nothing
     , seconds_left = 30
     , timer_stopped = False
     , show_answer = False
     , last_tick = Nothing
     }

randomQuestions : Seed -> List String -> List Int -> List InputQuestion -> List Question
randomQuestions s cats levs qs =
  let qdict = List.foldl
                (\q d ->
                  Dict.update (q.category, q.level)
                              (\ma -> case ma of
                                  Just a -> Just <| Array.push q a
                                  Nothing -> Just <| Array.fromList [q])
                              d)
                Dict.empty qs
      third = \(_,_,v) -> v
   in third
       <| List.foldl
          (\c (s2, ls, acc) ->
            let randomget = \l (s', acc2) ->
                  let (Just d) = Dict.get (c,l) qdict
                      (i, s3) = generate (int 0 ((Array.length d) - 1)) s'
                      (Just el) = Array.get i d
                  in (s3, { category = el.category
                          , level = el.level
                          , question = el.question
                          , answer = el.answer
                          , answered = False
                          } :: acc2)
                (s4, a') = List.foldl randomget (s2, []) ls
            in (s4, ls, acc ++ a'))
          (s, levs, [])
          cats

randomSeq : Seed -> Int -> Array a -> List a -> Trampoline (List a)
randomSeq s n vals accum =
  if n <= 0
  then Done accum
  else
    let (i,s2) = generate (int 0 <| (Array.length vals) - 1) s
        nvals = (Array.slice 0 i vals) `Array.append` (Array.slice (i+1) (Array.length vals) vals)
    in Continue <| \() ->
        case Array.get i vals of
          Just el -> randomSeq s2 (n-1) nvals (el :: accum)
          Nothing -> randomSeq s2 0 nvals accum
