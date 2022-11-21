https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
module TestPatterns where

import Automata

-- | A glider is a pattern that travels down and to the right.
glider :: Grid Conway
glider = parseGrid toConway 30 20 cells where
  cells = concat
    [ "                              "
    , "                              "
    , "                              "
    , "                              "
    , "     *                        "
    , "      *                       "
    , "    ***                       "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    , "                              "
    ]

-- | Simkin Glider Gun. It was first discovered in 2015.
-- https://www.conwaylife.com/ref/lexicon/lex_s.htm#simkinglidergun
simkin :: Grid Conway
simkin = parseGrid toConway 33 25 cells where
  cells = concat
    [ "................................."
    , "................................."
    , "................................."
    , "................................."
    , "................................."
    , "................................."
    , "**.....**........................"
    , "**.....**........................"
    , "................................."
    , "....**..........................."
    , "....**..........................."
    , "................................."
    , "................................."
    , "................................."
    , "................................."
    , "......................**.**......"
    , ".....................*.....*....."
    , ".....................*......*..**"
    , ".....................***...*...**"
    , "..........................*......"
    , "................................."
    , "................................."
    , "................................."
    , "................................."
    , "................................."
    ]

-- | Given a way to parse a character, and expected bounds of the
-- grid, parse a string describing cells into a grid.
parseGrid :: (Char -> c) -> Int -> Int -> String -> Grid c
parseGrid f w h cells
  | length cells == w * h = Grid w h (map f cells)
  | otherwise = error "parseGrid: dimensions don't match"

toConway :: Char -> Conway
toConway = undefined -- TODO
