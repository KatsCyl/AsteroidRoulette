{-# LANGUAGE ScopedTypeVariables, FlexibleInstances #-} -- allows "forall t. NetworkDescription t"

module AsteroidGame (main) where

import Control.Monad (when)
import Data.Maybe (isJust, fromJust)
import Data.List (nub)
import System.Random
import System.IO
import Debug.Trace
import Data.IORef

import Reactive.Banana as R
import Reactive.Banana.Frameworks as R

import AsteroidTexts
import AsteroidData

main :: IO ()
main = do
    displayHelpMessage
    source <- makeSource
    network <- compile $ setupNetwork source
    actuate network
    eventLoop source

makeSource = newAddHandler

eventLoop :: EventSource () -> IO ()
eventLoop roll = loop
    where
    loop = do
        putStr">> "
        hFlush stdout
        s <- getLine
        case s of
            "v" -> fire roll ()
            "q" -> return ()
            _      -> putStrLn $ s ++ " - unknown"
        when (s /= "q") loop

type EventSource a = (AddHandler a, a -> IO ())

addHandler :: EventSource a -> AddHandler a
addHandler = fst

fire :: EventSource a -> a -> IO ()
fire = snd

setupNetwork :: forall t. Frameworks t =>
    EventSource () -> Moment t ()
setupNetwork esroll = do
    initialStdGen <- liftIO $ newStdGen
    eroll <- fromAddHandler $ addHandler esroll 

    let
      -- Behavior and event for the random number generator.
      bStdGen :: Behavior t StdGen
      eNewRand :: Event t Int
      (eNewRand, bStdGen) = mapAccum initialStdGen (rand <$> eDoesRoll)

      rand :: () -> StdGen -> (Int, StdGen)
      rand () gen0 = (x, gen1)
          where
          random = randomR(1,6)
          (x, gen1) = random gen0

      -- Behavior and event for the GameState
      bGameState :: Behavior t GameState
      eGameState :: Event t GameState
      (eGameState, bGameState) = mapAccum initialGameState . fmap (\x y -> (x y, x y)) $ updateGameState <$> eNewRand

      eDoesRoll :: Event t ()
      eDoesRoll = filterApply ((\x _ -> isAlive x) <$> bGameState) eroll

      eAsteroid :: Event t Int
      eAsteroid = filterE (>= 1) $ asteroidFromGS <$> eGameState

      eWin :: Event t ()
      eWin = () <$ filterE (\x -> getShipPos x == 6) eGameState

      eDie :: Event t ()
      eDie = () <$ filterE isDead eGameState

    --reactimate $ displayShipState <$> eShipState
    reactimate $ putStrLn . showRoll <$> eNewRand
    reactimate $ displayAsteroidMessage <$> eAsteroid
    reactimate $ displayWinMessage <$ eWin
    reactimate $ displayDieMessage <$ eDie
    reactimate $ displayShipStatus . getShip <$> eGameState

showRoll y = "You rolled: " ++ show y
