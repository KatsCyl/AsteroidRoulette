module AsteroidTexts where

import AsteroidData

displayWinMessage :: IO ()
displayWinMessage =mapM_ putStrLn $
    "---------------------------------------":
    "--------------YOU MADE IT--------------":
    "-----------CONGRATULATIONS!------------":
    "--*no need to feel good about yourself-":
    "-----*this game contains no skill------":
    "---------------------------------------":
    []

displayHelpMessage :: IO ()
displayHelpMessage = mapM_ putStrLn $
    "---------------------------------------":
    "-----WELCOME TO THE ABYSS OF SPACE-----":
    "YOUR JOB IS TO GET FROM MARS TO JUPITER":
    "-----------------ALIVE-----------------":
    "Commands:                              ":
    "v - venture deeper               ":
    "q - quits game                      ":
    []

displayAsteroidMessage :: Int -> IO ()
displayAsteroidMessage x = putStrLn $
    "---------------------------------------\n\
    \YOU WERE HIT BY ASTEROID *" ++ a ++ "*\n\
    \---------------------------------------\n" ++
    asteroidDescription
    where
      a = fst $ getAsteroidString x
      asteroidDescription = snd $ getAsteroidString x
      getAsteroidString x= case x of
                                1 -> ("   tiny    ", tinyD)
                                2 -> ("paintruiner", prD)
                                3 -> (" nullifier ", nullD)
                                4 -> (" teleporter", teleD)
                                5 -> ("  stucker  ", stucD)
                                6 -> ("   Ceres   ", cereD)

displayDieMessage :: IO ()
displayDieMessage = mapM_ putStrLn $
    "---------------------------------------":
    "-----------YOU HAVE PERISHED!----------":
    "-------In a fatal asteroid crash.------":
    "-And now someone has to clean it all up":
    "-------------Great job...--------------":
    []
    
displayShipStatus :: Ship -> IO()
displayShipStatus (Ship pos shield stuck tele dead) = putStrLn $
    "---------------------------------------\n" ++
    "|SECTOR     "++x++"   "++t++"**"++t++"   "++x++"              |\n" ++
    "|  "++y++"       "++x++"   "++t++"****"++t++"   "++x++"             |\n" ++
    "|         "++x++"    "++t++"*"++e++"*"++t++"    "++x++"            |\n" ++
    "|        "++x++"     "++t++"****"++t++"     "++x++"           |\n" ++
    "|             "++t++"* * **"++t++"                |\n" ++
    "|            "++t++"* * * **"++t++"               |\n" ++
    "|            "++t++"* * * **"++t++"               |\n" ++
    "---------------------------------------\n"
      where
        x = (\z -> if z then "X" else " ") shield
        t = (\z -> if z then "T" else " ") tele
        e = (\z -> if z then "EE" else "  ") stuck
        y = show pos



tinyD :: String
tinyD = "--*TINY* JAMMED YOUR SHIELD GENERATORS-\n" ++
        "--------YOU NO LONGER HAVE SHIELDS-----"

prD :: String
prD = "-*PAINTSCRATCHER* RUINED YOUR BRAND NEW\n" ++
      "----------------PAINT JOB--------------"

nullD :: String
nullD = "--*NULLIFIER* PUSHED YOU BACK TO MARS--\n" ++
        "-------BETTER KEEP VENTURING-----------"

teleD :: String
teleD = "----*TELEPORTER* PUSHED YOU INTO A-----\n" ++
        "---------------WORM HOLE---------------"

stucD :: String
stucD = "--*STUCKER* MANAGED TO SHUT DOWN YOUR--\n" ++
        "---------------ENGINES-----------------"

cereD :: String
cereD = "----THE MASSIVE *CERES* HAS ENDED------\n" ++
        "-------------YOUR DAYS-----------------"
