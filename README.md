AsteroidRoulette
================

This is a simple little command line game based off of
the game played in the book "Gobsmacking Galaxy (The Knowledge)" by Kjartan Poskitt.

Rules of the game:
------------------
Object of the game is to get from Mars (Sector 0) to Jupiter (Sector 6) through the
extremely dangerous asteroid belt.

You start from sector 0. You move to the next sector by rolling the number of the next 
sector, e.g you are in sector 4, you roll 5, you move to sector 5.

You get hit by an asteroid if your roll the same number twice in a row. Each number corresponds
to a different asteroid:
  * 1 = tiny asteroid, which makes you lose your shields
  * 2 = tiniest asteroid, which does nothing
  * 3 = nullfier asteroid, which pushes you back to sector 0
  * 4 = teleporter asteroid, which pushes you to a worm hole, causing you to warp to the sector shown by your next roll
  * 5 = stucker asteroid, which shuts down your engines, you cant move before you start your engines again by throwing another 5
  * 6 = Ceres, which annhiliates you instantly

You also die from any asteroid if you do not have your shields up.

Installing:
----------
1. `git clone https://github.com/KatsCyl/AsteroidRoulette.git && cd AsteroidRoulette`
2. `cabal sandbox init`
3. `cabal install`
4. `./.cabal-sandbox/bin/AsteroidRoulette`
