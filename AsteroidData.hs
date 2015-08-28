module AsteroidData where

data Ship = Ship {pos :: Int
                 , shields :: Bool
                 , stuck :: Bool
                 , tele :: Bool
                 , dead :: Bool}

type Throw = (Int, Int, Int)

type GameState = (Ship, Throw)

initialGameState :: GameState
initialGameState = ((Ship 0 True False False False), (0, 0, 0))

getShip :: GameState -> Ship
getShip = fst

getThrows :: GameState -> Throw
getThrows = snd

isAlive :: GameState -> Bool
isAlive (ship, _) = not $ dead ship

asteroidFromGS :: GameState -> Int
asteroidFromGS (_, (x, y, _)) = if y == x then x else -1

getShipPos :: GameState -> Int
getShipPos (s, _) = pos s

isDead :: GameState -> Bool
isDead (s, _) = dead s

updateShipA :: Int -> Ship -> Ship
updateShipA as s = if shields s then
                     case as of
                       1 -> deShield s
                       2 -> s
                       3 -> gNull s
                       4 -> gTele s
                       5 -> gStuck s
                       6 -> kill s
                    else
                      kill s
                    where
                      deShield (Ship p _ st tl d) = Ship p False st tl d
                      gNull (Ship _ sh st tl d) = Ship 0 sh st tl d
                      gTele (Ship p sh st _ d) = Ship p sh st True d
                      gStuck (Ship p sh _ tl d) = Ship p sh True tl d
                      kill (Ship p sh st tl _) = Ship p sh st tl True

updateShipM :: Int -> Ship -> Ship
updateShipM m s = if tele s then
                    mShip m s
                  else
                    if stuck s then
                      if m == 5 then
                        dStuck s
                      else
                        s
                    else
                      if m == (pos s + 1) then
                        next s
                      else
                        s
                  where
                    mShip p (Ship _ sh st _ d) = Ship p sh st False d
                    dStuck (Ship p sh _ tl d) = Ship p sh False tl d
                    next (Ship p sh st tl d) = Ship (p + 1) sh st tl d

                      



updateGameState :: Int -> GameState -> GameState
updateGameState r (ship, (_, ppr, pr)) = if fst $ asteroid (ppr, pr, r) then
                                           (updateShipA (snd $ asteroid (ppr, pr, r)) ship, (pr, r, 0))
                                         else
                                           (updateShipM r ship, (ppr, pr,r))

asteroid :: Throw -> (Bool, Int)
asteroid (_, x, y) = (x == y, x)
