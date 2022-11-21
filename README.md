# COMP1100 Assignment 2

In this assignment, you will write code to explore some simple
computational models called [Cellular
Automata](https://en.wikipedia.org/wiki/Cellular_automaton). A
Cellular Automaton is a grid of cells, and a rule that describes how
cells change over discrete time steps. These can be used to (crudely)
model all sorts of interesting things, like biological systems,
electronics and liquids. The opening ten or so minutes of the [Noita
GDC talk](https://www.youtube.com/watch?v=prXuyMCgbTc) show some
clever effects built out of simple rules.


{:.msg-info}
This assignment is worth 12% of your final grade.

{:.msg-warn}
**Deadline**: Sunday 10 May, 2020, at 11:00pm Canberra time *sharp*

## Overview of Tasks

This assignment is marked out of 100 for COMP1100, and out of 120 for
COMP1130:

| **Task**                                 | **COMP1100** | **COMP1130** |
|------------------------------------------|--------------|--------------|
| Task 1: Types and Helper Functions       | 25           | 20           |
| Task 2: Implementing Cellular Automata   | 35           | 30           |
| Task 3: Custom Automaton (COMP1130 Only) | N/A          | 20           |
| Unit Tests                               | 10           | 10           |
| Style                                    | 10           | 10           |
| Technical Report                         | 20           | 30           |

{:.msg-warn}
From this assignment onward, code that does not compile and run will be penalised heavily. This means that **both** the commands `cabal v2-run automata` **and** `cabal v2-test` must run without errors. If **either** if those commands fails with an error, a heavy mark deduction will be applied. If you have a partial solution that you cannot get working, you
should comment it out and write an additional comment directing your
tutor's attention to it.


## Getting Started

Fork the assignment repository and clone it to your computer,
 following the same steps as in [Lab
 2](https://cs.anu.edu.au/courses/comp1100/labs/02/#forking-a-project). The
 assignment repository is at
 <https://gitlab.cecs.anu.edu.au/comp1100/2020s1studentfiles/assignment2.git>.


## Overview of the Repository

For COMP1100 students, most of your code will be written in
`src/Automata.hs`, and a little
in `src/TestPatterns.hs`.
You will also need to implement tests in
`src/AutomataTest.hs`, which contains some example tests for you to
study.
COMP1130 students will also need to write code in `src/App.hs`.

### Other Files

* `src/TestPatterns.hs` contains some test patterns for the automata
  in this assignment.

* `src/Testing.hs` is the testing library we used in Assignment 1. You
  should read this file as well as `src/AutomataTest.hs`, and make sure
  you understand how to write tests.

* `src/GridRenderer.hs` contains code to render a grid of cells to the
  screen, and to convert a point on the screen back into a grid
  coordinate. You are not required to understand it, but it is heavily
  commented for interested students to read.

* `src/App.hs` contains the bulk of a small CodeWorld test program
  that uses your automata code. We discuss its features in "Overview
  of the Test Program".

* `app/Main.hs` launches the test application.

* `test/Main.hs` is a small program that runs the tests in
  `src/AutomataTest.hs`.

* `comp1100-assignment2.cabal` tells the cabal build tool how to build
  your assignment. You are not required to understand this file, and
  we will discuss how to use cabal below.

* `Setup.hs` tells cabal that this is a normal package with no unusual
  build steps. Some complex packages (that we won't see in this
  course) need to put more complex code here. You are not required to
  understand it.

## Overview of Cabal

As before, we are using the `cabal` tool to build the assignment
code. The commands provided are very similar to last time:

* `cabal v2-build`: Compile your assignment.

* `cabal v2-run automata`: Build your assignment (if necessary), and
  run the test program.

* `cabal v2-repl comp1100-assignment2`: Run the GHCi interpreter over
  your project.

* `cabal v2-test`: Build and run the tests. This assignment is set up
   to run a unit test suite like in Assignment 1, but this time you
   will be writing the tests. The unit tests will abort on the first
   failure, or the first call to a function that is `undefined`.

{:.msg-info}
You should execute these cabal commands in the **top-level directory** of your
project: `~/comp1100/assignment2` (i.e., the directory you are in when you
launch a terminal from VSCodium).


## Overview of the Test Program

The test program in `app/Main.hs` uses CodeWorld, just like Assignment
1, and responds to the following keys:

| Key          | Effect                                          |
|--------------|-------------------------------------------------|
| `1`          | Reset the simulation to the first test pattern  |
| `2`          | Reset the simulation to the second test pattern |
| `C`          | Switch to Conway's Game of Life (COMP1130 only) |
| `.`          | Evolve one generation of the simulation         |
| `<Spacebar>` | Evolve multiple generations of the simulation   |
| `+`          | Make `<Spacebar>` evolve more generations       |
| `-`          | Make `<Spacebar>` evolve fewer generations      |

You can also click on cells with the mouse to change them, if you want
to play around with different patterns.

{:.msg-warn}
If you try to use the test program without completing Task 1, or you
try to run the simulation before completing Task 2, the test program
may crash with the following error:

```
"Exception in blank-canvas application:"
Prelude.undefined
```

If this happens, refresh the browser to continue.


## Overview of Cellular Automata

A cellular automaton is a simulation made up of a grid of cells. The
simulation proceeds in discrete time-steps: to compute the next
generation of the simulation, we apply a _rule_ to each cell that
looks at itself and its _neighbourhood_ (the set of its eight
immediate neighbours - up, down, left, right, and the diagonals) and
returns what the new cell should be.

In this assignment, you will be implementing a classic cellular
automaton from the literature: [Conway's Game of
Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life).

{:.msg-info}
Tragically, [John Conway passed away from
COVID-19](https://arstechnica.com/science/2020/04/john-conway-inventor-of-the-game-of-life-has-died-of-covid-19/)
a few days before this assignment was released. While he was most
famous for his Game of Life, [his work was much wider than
that](https://www.i-programmer.info/news/82-heritage/13614-john-conway-dies-from-coronavirus.html). He
talks a little about some of his other work [on
Numberphile](https://www.youtube.com/playlist?list=PLt5AfwLFPxWIL8XA1npoNAHseS-j1y-7V).


### Conway's Game of Life

Conways's game of life is a classic cellular automaton, and probably
the one most people think of when they hear the phrase. Conway
designed the _rule_ for his game carefully, with [three
objectives](https://web.stanford.edu/class/sts145/Library/life.pdf) in
mind:

> 1. There should be no initial pattern for which there is a simple
>    proof that the population can grow without limit.
>
> 2. There should be initial patterns that apparently do grow without
>    limit.
>
> 3. There should be simple initial patterns that grow and change for
>    a considerable period of time before coming to end in three
>    possible ways: fading away completely (from overcrowding or
>    becoming too sparse), settling into a stable configuration that
>    remains unchanged thereafter, or entering an oscillating phase in
>    which they repeat an endless cycle of two or more periods.
>
> In brief, the rules should be such as to make the behavior of the
> population unpredictable.

The _rule_ for Conway's Game of Life is:

* Cells can be _alive_ or _dead_.
* If a cell is _alive_:
  - If fewer than two of its neighbours are _alive_, it gets lonely and becomes _dead_.
  - If more than three of its neighbours are _alive_, it gets overcrowded and
    becomes _dead_.
  - All other _alive_ cells (those with two or three _alive_ neighbours)
    remain _alive_.
* If a cell is _dead_:
  - If it has exactly three _alive_ neighbours, it becomes _alive_.
  - All other _dead_ cells remain _dead_.

These rules produce a kaleidoscope of interesting patterns and
behaviours.


#### Test Patterns

Test Pattern 1 is called a _glider_. It will travel down and to the
right, and on an infinite grid, will run forever.

{:.msg-info}
In another tragic coincidence, the mathematician who discovered the
glider, [Richard K. Guy](https://en.wikipedia.org/wiki/Richard_K._Guy)
also passed away in March of this year.

Test Pattern 2 is called the _Simkin Glider Gun_, and was only
discovered in 2015. (Other glider guns have been known for some time,
but this is the one with smallest known number of live cells.) It runs
forever, spitting out gliders above and below.


## Task 1: Types and Helper Functions (COMP1100: 25 Marks; COMP1130: 20 Marks)

Before we can begin implementing the rules for our cellular automata,
we need to set up a few things:

1. Data types to represent each sort of cell;
2. Helper functions over cells; and
3. Helper functions for our `Grid` data type.

The assignment framework will use these functions to render entire
grids of cells to CodeWorld `Picture`s.


### Your Tasks

In `src/Automata.hs`, fill out the data type `Conway` that represents
cells in the game of life. Defining our own type to talk about cells
lets us be precise when we code, which reduces bugs.

In `src/TestPatterns.hs`, there are two test patterns for Conway's
Game of Life, expressed as `String`s. The `parseGrid` function
_parses_ these strings into values of type `Grid Conway`, which are
made available to the rest of the program. (_Parsing_ is the process
of analysing unstructured data - usually strings or binary data - and
converting it into a more structured form.)

`parseGrid` relies on a helper function to parse individual characters
into cells. For Conway's Life, the helper is `toConway :: Char ->
Conway`, which you need to implement. It shall turn a character from a
Conway test pattern into a Conway cell, according to the following
rule:

  - A `'*'` character represents an _alive_ cell.
  - Any other character represents a _dead_ cell.

We provide a test program that uses CodeWorld to draw the cells to the
screen, and allows you to edit the grid by clicking on it. It relies
on some helper functions in `src/Automata.hs`, which you need to
implement:

* The test program allows the user to change cells by clicking on
  them. This relies on `cycleConway :: Conway -> Conway`, which
  returns what the cell should be after it is clicked. This function
  needs to return the "next" type of Conway cell, similar to
  `nextColour` from Assignment 1. The "next" of an _alive_ cell is a
  _dead_ cell, and the "next" of a _dead_ cell is an _alive_ cell.

* The test program knows how to draw a `Grid` of cells, provided that
  it can be told how to draw a single cell from the grid. It uses
  `renderConway :: Conway -> Picture` to do this, which needs to
  behave according to the following rules:

  - _Dead_ cells shall be drawn as hollow black rectangles, 1x1 in
    size, centred at the origin.

  - _Alive_ cells shall be drawn as solid blue rectangles, 1x1 in
    size, centred at the origin.

The test program requires two more helpers in `src/Automata.hs` that
deal with the grid as a whole. You might also find them useful in Task
2:

* `get :: Grid c -> GridCoord -> Maybe c`

  - The test program uses `get` when it responds to mouse clicks, to
    pick out the cell that the user is changing.

  - `get g (x,y)` shall return `Just` the cell at position `(x,y)`, if
    it exists. If it does not (i.e., `x` or `y` are outside the bounds
    of the `Grid`), it shall return `Nothing`.

  - Both `x` and `y` count from `0`. That is, `(0,0)` is the top-left
    corner of the grid.

  - The cells in a `Grid` are stored as a single list, in what we call
    _row-major_ order. This means that the list contains every cell in
    row `0`, then every cell in row `1`, then every cell in row `2`,
    and so on...

* `allCoords :: Int -> Int -> [GridCoord]`

  `allCoords width height` shall return a list of every possible
  coordinate in a grid of that width and height, in row-major
  order. It is important that you emit coordinates in this order, as
  the assignment skeleton assumes that the list of cells in a grid is
  stored in the same order. The renderer in the test program uses
  `allCoords` to decide where to place the `Picture` of each cell in
  the grid.

  Both `width` and `height` must be positive integers to return a
  sensible result. Raise an error if either are zero or negative.

  - Example: `allCoords 3 2` shall return
    `[(0,0),(1,0),(2,0),(0,1),(1,1),(2,1)]`.

### Hint

* The function `(!!) :: [a] -> Int -> a` can return the `n`th element
  of a list:

  - Example: `['a', 'b', 'c'] !! 2` returns `'c'`.

  - Example: `[] !! 0` throws an error, as the index is beyond the
    length of the list.

  - You don't want to use this function often (because of the risk of
    errors), but it is a handy tool here.


## Task 2: Running Cellular Automata (COMP1100: 35 Marks; COMP1130: 30 Marks)

We can now render the cellular automata grids in CodeWorld. The next
step is to make them evolve according to Conway's rules.

### Your Task

Define the following two functions in `src/Automata.hs`:

* `nextGenConway :: Grid Conway -> Grid Conway` computes the next
  generation of Conway's Life according to its _rule_; and

* `evolveConway :: Int -> Grid Conway -> Grid Conway`, which evolves
  the grid a given number of times. If given a negative number,
  `evolveConway` shall raise an error.

### Hints

* Break the problem down into subproblems (separate functions), and
  test each in isolation. If you find a function does not do what you
  expect, you will have smaller units of code to debug. This is easier
  to get your head around.

* Here are some questions you might need to ask when formulating a
  solution; some of them could be turned into helper functions:

  - Given a coordinate for a cell on a grid, what is its
    _neighbourhood_ (the eight cells around that coordinate: one step
    up, down, left, right, and the diagonals)?

    **Style Note:** You can split complex expressions over multiple
    lines, for readability:

    ```haskell
    -- This calculation is pointless but long.
    -- Instead of writing it out like this:
    fiveFactorials = [1, 1 * 2, 1 * 2 * 3, 1 * 2 * 3 * 4, 1 * 2 * 3 * 3 * 5]

    -- Why not write it out like this?
    fiveFactorials =
      [ 1
      , 1 * 2
      , 1 * 2 * 3
      , 1 * 2 * 3 * 4
      , 1 * 2 * 3 * 3 * 5
      ]

    -- P.S.: Did you notice the bug?
    -- It's easier to see in the second example, isn't it?
    ```

  - Given a _neigbourhood_, how many cells are of some particular
    type?

  - Given a _cell_ and its _neighbourhood_, what will the next cell
    look like?

* Do the helper functions from Task 1 solve any of your subproblems?

* The list of cells within a `Grid c` is in row-major order. The list
  of coordinates returned by `allCoords` is in row-major order. Can
  you do anything useful by using both simultaneously?


## Task 3: Custom Automaton (COMP1130 Only: 20 Marks)

Cellular automata can be used to model a wide variety of systems. In
this task, we challenge you to invent an automaton of your own to
model some (probably physical) process.

### Your Task

Think of a physical process or the behaviour of some system. Define a
cellular automaton to simulate that process/system, and implement it
in the assignment framework, including all the functionality that was
implemented for Conway's Game of Life in the earlier parts of the
assignment.

{:.msg-warn}
Custom automata that are basically Conway's Game of Life will not be
marked favourably. Neither will trivial automata such as "I'm modeling
the vacuum of space. The only cells in my system are `Empty`, and all
`Empty` cells stay `Empty` in the nexet generation." Don't be silly!

You will need to:

* Define a data type for its cells. Traditional cellular automata tend
  to use enumerations for the cell type, but you are free to use the
  full power of Haskell's algebraic data types where that makes sense
  in your simulation.

* Define a _rule_ for your automaton, which should consider only the
  current cell and its neighbours. The rule for Conway's life
  considers the cells in a neighbourhood without regard to direction;
  if your simulation models processes like gravity or buoyancy, your
  _rule_ can check things like "the cell above".

* Define a function that computes the next generation of your
  automaton.

* Define a function that evolves your automaton an integer number of
  steps.

* Define a rendering function for your cell type. So long as the
  `Picture` it produces is 1x1 CodeWorld units in size, the renderer
  will render the entire grid correctly.

* Define two test patterns in `src/TestPatterns.hs` for your
  automaton.

* Make all of the above work with the test program in
  `src/App.hs`. The user needs to be able to:

  - Use the keyboard to switch between Conway's Game of Life and your automaton;
  - Select either of your test patterns, using the existing key bindings;
  - Advance one step at a time by pressing `.`;
  - Jump forward multiple steps using `<Spacebar>`; and
  - Change the grid by clicking on it (you can decide what's sensible
    here - toggling cells made sense for Conway, but might not for
    your automata).

* Discuss your automaton in your report, making sure to explain how it models
  your chosen process/system.

#### Hints

* When handling the `ClickCell` case in `applyEvent`, use either `at`
  or `setAt` to "update" the grid at one particular cell.

* If you are stuck thinking of a system to model, here are some ideas:

  - Movement of liquids
  - Diffusion of heat or gases
  - Fire
  - Electricity
  - Units moving around a board or battlefield (this seems harder than
    the others - be careful that units don't spontaneously duplicate
    or disappear)

  You are not required to follow any of these suggestions. If you have
  your own exciting idea, then please pursue that!

* When making large changes like this, you can often "follow the
  types". This is a useful procedure for making changes in
  strongly-typed languages like Haskell: make a change to a type and
  then repeatedly attempt to build your program. GHC will issue type
  errors and warnings which tell you where the problems are in the
  rest of your code. As you fix those, and rebuild, you will "push"
  the errors out of your program.


## Unit Tests (10 Marks)

How do you know that the program you've written is correct? GHC's type
checker rejects a lot of invalid programs, but you've written enough
Haskell by now to see that a program that compiles is not necessarily
correct. Testing picks up where the type system leaves off, and gives
you confidence that changing one part of a program doesn't break
others. You have written simple doctests in your labs, but larger
programs need more tests, so the tests you will write for this
assignment will be labelled and organised in a separate file from the
code.

Open `src/AutomataTest.hs`. This file contains a couple of example
test cases, written using a simple test framework defined in
`src/Testing.hs`. These files are heavily commented for your
convenience.

You can run the tests by executing `cabal v2-test`. If it succeeds it
won't print out every test that ran, but if it fails you will see the
output of the test run. If you want to see the tests every time, use
`cabal v2-test --test-show-details=streaming` instead.

### Your Task

Replace the example tests with tests of your own. The tests that you
write should show that the Haskell code you've written in Tasks 1-3
is working correctly.

#### Hints

##### General Hints

* Try writing tests before you write code. Then work on your code
  until the tests pass. Then define some more tests and repeat. This
  technique is called _test-driven development_.

* The expected values in your test cases should be easy to check by
  hand. If the tested code comes up with a different answer, then it's
  clear that the problem is with the tested code and not the test
  case.

* Sometimes it is difficult to check an entire structure that's
  returned from one of your functions. Maybe you can compute some
  feature about your result that's easier to test?

* If you find yourself checking something in GHCi (i.e., `cabal
  v2-repl comp1100-assignment2`), ask yourself "should I make this
  into a unit test?". The answer is often "yes".

* If you are finding it difficult to come up with sensible tests, it
  is possible that your functions are doing too many things at
  once. Try breaking them apart into smaller functions and writing
  tests for each.

##### Technical Hints

* The `assertEqual` and `assertNotEqual` functions will not work on
  the CodeWorld `Picture` type (it has no `Eq` instance). Therefore,
  it is not possible to write tests for `renderConway`.

* If you want to write tests about new types you have defined, add
  `deriving (Eq, Show)` to the end of the type definition, like this:

  ```data MyType = A | B | C deriving (Eq, Show)```

* It is not possible to test for a call to `error` using the tools
  provided in this course.


## Style (10 Marks)

> "[...] programs must be written for people to read, and only
> incidentally for machines to execute."

From the foreword to the first edition of [Structure and
Interpretation of Computer Programs](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-7.html).

Programming is a brain-stretching activity, and you want to make it as
easy on yourself as possible. Part of that is making sure your code is
easy to read, because that frees up more of your brain to focus on the
harder parts.

Guidance on good Haskell style can be found in [this course's Style
Guide](https://cs.anu.edu.au/courses/comp1100/resources/02-style/),
and in [lecture
notes](https://cs.anu.edu.au/courses/comp1100/lectures/05-3-Code_Quality.pdf).

### Your Task

Ensure that your code is written in good Haskell style.


## Technical Report (COMP1100: 20 Marks; COMP1130: 30 Marks)

You are to write a concise [technical
report](https://cs.anu.edu.au/courses/comp1100/resources/07-reports/)
about your assignment.

The **maximum word count** is **1250** for COMP1100 students, and
**2000** for COMP1130 students. This is a *limit*, not a *quota*;
concise presentation is a virtue.

{:.msg-warn}
Once again: This is not a required word count. They are the **maximum
number of words** that your marker will read. If you can do it in
fewer words without compromising the presentation, please do so.

Your report must be in PDF format, located at the root of your
assignment repository on GitLab and named `Report.pdf`. Otherwise, it
may not be marked.

The report must have a **title page** with the following items:

* Your name
* Your laboratory time and tutors
* Your university ID

An excellent report will:

* Demonstrate a conceptual understanding of all major functions, and how
  they interact when the program as a whole runs;

* Explain your design process, including your assumptions, and the
  reasons behind choices you made;

* Discuss how you tested your program, and in particular why your
  tests give you confidence that your code is correct; and

* Be well-formatted without spelling or grammar errors.


### Content and Structure

Your audience is the tutors and lecturers, who are proficient at
programming and understand the concepts taught in this course. You
should not, for example, waste words describing the syntax of Haskell
or how recursion works. After reading your technical report, the
reader should thoroughly understand what problem your program is
trying to solve, the reasons behind major design choices in it, as
well as how it was tested. Your report should give a broad overview of
your program, but focus on the specifics of what *you* did and why.

Remember that the tutors have access to the above assignment
specification, and if your report *only* contains details from it then
you will only receive minimal marks. Below is a potential outline for
the structure of your report and some things you might discuss in it.

#### Introduction

If you wish to do so you can write an introduction. In it, give:

* A brief overview of your program:

  - how it works; and
  - what it is designed to do.

#### Content

<br/>

Talk about why you structured the program the way you did. Below are some
questions you could answer:

* Program design
  - Describe what each relevant function does conceptually. (i.e. how
    does it get you closer to solving the problems outlined in this
    assignment spec?)
  - How do these functions piece together to make the finished
    program? Why did you design and implement it this way?
  - What major design choices did *you* make regarding the functions
    that *you’ve* written, and the overall structure of your program?

* Assumptions
  - Describe any assumptions that you needed to make, and how they
    have influenced your design decisions.

* Testing
  - How did you test individual functions?
    - Be specific about this - the tutors know that you have tested
      your program, but they want to know *how*.
    - Describe the tests that prove individual functions on their own
      behave as expected (i.e. testing a function with different
      inputs and doing a calculation by hand to check that the outputs
      are correct).
  - How did you test the entire program? What tests did you perform to
    show that the program behaves as expected in all (even unexpected)
    cases?
  - Again, be specific - did you just check that you can draw the
    triangles and polygons from Task 1, or did you come up with
    additional examples?

* Inspiration / external content
  - What resources did you use when writing your program (e.g.,
    published algorithms)?
  - If you have used resources such as a webpage describing an
    algorithm, be sure to cite it properly at the end of your report
    in a ‘References’ section. References do not count to the maximum
    word limit.

#### Reflection

Discuss the reasoning behind your decisions, rather than *what* the
decisions were. You can reflect on not only the decisions you made,
but the process through which you developed the final program:

* Did you encounter any conceptual or technical issues?
  - If you solved them, describe the relevant details of what happened
    and how you overcame them.
  - Sometimes limitations on time or technical skills can limit how
    much of the assignment can be completed. If you ran into a problem
    that you could not solve, then your report is the perfect place to
    describe them. Try to include details such as:
    - theories as to what caused the problem;
    - suggestions of things that might have fixed it; and
    - discussion about what you did try, and the results of these attempts.

* What would you have done differently if you were to do it again?
  - What changes to the design and structure you would make if you
    wrote the program again from scratch?

* Are parts of the program confusing for the reader? You can explain
  them in the report (in this situation you should also make use of
  comments in your code).

* If you collaborated with others, what was the nature of the
  collaboration?  (Note that you are only allowed to collaborate by
  sharing ideas, not code.)
  - Collaborating is any discussion or work done together on planning
    or writing your assignment.

* Other info
  - You may like to briefly discuss details of events which were
    relevant to your process of design - strange or interesting things
    that you noticed and fixed along the way.

{:.msg-info}
This is a list of **suggestions**, not requirements. You should only
discuss items from this list if you have something interesting to
write.

### Things to avoid in a technical report

* Line by line explanations of large portions of code. (If you want to
  include a specific line of code, be sure to format as described in
  the "Format" section below.)
* Pictures of code or VSCodium.
* Content that is not your own, unless cited.
* Grammatical errors or misspellings. Proof-read it before submission.
* Informal language - a technical report is a professional document, and as
  such should avoid things such as:
  - Unnecessary abbreviations (atm, btw, ps, and so on), emojis, and
    emoticons; and
  - Recounting events not relevant to the development of the program.
* Irrelevant diagrams, graphs, and charts. Unnecessary elements will
  distract from the important content. Keep it succinct and focused.

If you need additional help with report writing, the [academic skills
writing
centre](http://www.anu.edu.au/students/academic-skills/appointments/academic-skills-writing-centre)
has a peer writing service and writing coaches.

### Format

You are not required to follow any specific style guide (such as APA
or Harvard). However, here are some tips which will make your report
more pleasant to read, and make more sense to someone with a computer
science background.

* Colours should be kept minimal. If you need to use colour, make sure it is
  absolutely necessary.
* If you are using graphics, make sure they are *vector* graphics (that stay
  sharp even as the reader zooms in on them).
* Any code, including type/function/module names or file names, that
  appears in your document should have a monospaced font (such as
  Consolas, Courier New, Lucida Console, or Monaco)
* Other text should be set in serif fonts (popular choices are Times,
  Palatino, Sabon, Minion, or Caslon).
* When available, automatic *ligatures* should be activated.
* Do not use underscore to highlight your text.
* Text should be at least 1.5 spaced.


## Communication

**Do not** post your code publicly, either on Piazza or via other
forums. Posts on Piazza trigger emails to all students, so if by
mistake you post your code publicly, others will have access to your
code and you may be held responsible for plagiarism.

Once again, and we cannot stress this enough: **do not post your code
publicly** . If you need help with your code, post it *privately* to the
instructors.

When brainstorming with your friends, **do not share code** and **do not share detailed descriptions of your design**. There
might be pressure from your friends, but this is for both your and
their benefit. Anything that smells of plagiarism will be investigated
and there may be serious consequences.

Course staff will not look at assignment code unless it is posted
**privately** in Piazza, or in a drop-in consultation.

Course staff will typically give assistance by asking questions,
directing you to relevant exercises from the labs, or definitions and
examples from the lectures.

{:.msg-info}
Before the assignment is due, course staff will not give individual
tips on writing functions for the assignment or how your code can be
improved. We will help you get unstuck by asking questions and
pointing you to relevant lecture and lab material. You will receive
feedback on you work when marks are released.


## Submission Advice

Start early, and aim to finish the assignment several days before the
due date. At least 24 hours before the deadline, you should:

* Re-read the specification one final time, and make sure you've
  covered everything.

* Confirm that the latest version of your code has been pushed to
  GitLab by using your browser to visit
  https://gitlab.cecs.anu.edu.au/uXXXXXXX/assignment2, where XXXXXXX
  is your student number.

* Ensure your program compiles and runs, including the `cabal v2-test`
  test suite.

* Proof-read and spell-check your report.

* Verify that your report is in PDF format, in the root of the project
  directory (not in `src`), and named `Report.pdf`. That capital `R`
  is important - Linux uses a case-sensitive file system. Check that
  you have successfully added it in GitLab.
# COMP1100 Assignment 2
# 加微信 powcoder

# [代做各类CS相关课程和程序语言](https://powcoder.com/)

# Programming Help Add Wechat powcoder

# Email: powcoder@163.com

[成功案例](https://powcoder.com/tag/成功案例/)

[java代写](https://powcoder.com/tag/java/) [c/c++代写](https://powcoder.com/tag/c/) [python代写](https://powcoder.com/tag/python/) [drracket代写](https://powcoder.com/tag/drracket/) [MIPS汇编代写](https://powcoder.com/tag/MIPS/) [matlab代写](https://powcoder.com/tag/matlab/) [R语言代写](https://powcoder.com/tag/r/) [javascript代写](https://powcoder.com/tag/javascript/)

[prolog代写](https://powcoder.com/tag/prolog/) [haskell代写](https://powcoder.com/tag/haskell/) [processing代写](https://powcoder.com/tag/processing/) [ruby代写](https://powcoder.com/tag/ruby/) [scheme代写](https://powcoder.com/tag/drracket/) [ocaml代写](https://powcoder.com/tag/ocaml/) [lisp代写](https://powcoder.com/tag/lisp/)

- [数据结构算法 data structure algorithm 代写](https://powcoder.com/category/data-structure-algorithm/)
- [计算机网络 套接字编程 computer network socket programming 代写](https://powcoder.com/category/network-socket/)
- [数据库 DB Database SQL 代写](https://powcoder.com/category/database-db-sql/)
- [机器学习 machine learning 代写](https://powcoder.com/category/machine-learning/)
- [编译器原理 Compiler 代写](https://powcoder.com/category/compiler/)
- [操作系统OS(Operating System) 代写](https://powcoder.com/category/操作系统osoperating-system/)
- [计算机图形学 Computer Graphics opengl webgl 代写](https://powcoder.com/category/computer-graphics-opengl-webgl/)
- [人工智能 AI Artificial Intelligence 代写](https://powcoder.com/category/人工智能-ai-artificial-intelligence/)
- [大数据 Hadoop Map Reduce Spark HBase 代写](https://powcoder.com/category/hadoop-map-reduce-spark-hbase/)
- [系统编程 System programming 代写](https://powcoder.com/category/sys-programming/)
- [网页应用 Web Application 代写](https://powcoder.com/category/web/)
- [自然语言处理 NLP natural language processing 代写](https://powcoder.com/category/nlp/)
- [计算机体系结构 Computer Architecture 代写](https://powcoder.com/category/computer-architecture/)
- [计算机安全密码学computer security cryptography 代写](https://powcoder.com/category/computer-security/)
- [计算机理论 Computation Theory 代写](https://powcoder.com/category/computation-theory/)
- [计算机视觉(Compute Vision) 代写](https://powcoder.com/category/计算机视觉compute-vision/)

