https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
module Automata where

import CodeWorld

-- | A 'Grid' of some cell type c consists of a pair of positive ints
-- describing its width and height, along with a list of cs that is
-- exactly (width * height) long.
data Grid c = Grid Int Int [c]

-- | Type alias for grid coordinates. This makes it clear when we are
-- talking about grid coordinates specifically, as opposed to some
-- other pair of integers.
type GridCoord = (Int, Int)


-- | Type of cells used in Conway's game of life.
data Conway = DeadCells GridCoord
              LiveCells GridCoord

cycleConway :: Conway -> Conway
cycleConway = undefined -- TODO

renderConway :: Conway -> Picture
renderConway = undefined -- TODO

nextGenConway :: Grid Conway -> Grid Conway
nextGenConway = undefined -- TODO

evolveConway :: Int -> Grid Conway -> Grid Conway
evolveConway = undefined -- TODO


get :: Grid c -> GridCoord -> Maybe c
get = undefined -- TODO

allCoords :: Int -> Int -> [GridCoord]
allCoords = undefined -- TODO
