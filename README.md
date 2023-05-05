# automata-engine
A general cellular automata engine implemented in lua using [Love2d](https://love2d.org/) for visualisation

Inspired by [this](https://www.youtube.com/watch?v=ygdPRlSo3Qg)

# TODO
- [x] Implemented engine.
- [x] Implemented visualisation.
- [x] Implemented basic interactions(more like controls) with the visualisation.
- [ ] Add other automata to simulate.
  - [ ] [Brian's Brain](https://en.wikipedia.org/wiki/Brian%27s_Brain)
  - [ ] [Seeds](https://en.wikipedia.org/wiki/Seeds_(cellular_automaton))
  - [ ] [Codd](https://en.wikipedia.org/wiki/Codd%27s_cellular_automaton)
  - [ ] [Day and Night](https://en.wikipedia.org/wiki/Day_and_Night_(cellular_automaton))
  - [ ] [Turmite](https://en.wikipedia.org/wiki/Turmite)
  - [ ] [Wireworld](https://en.wikipedia.org/wiki/Wireworld)(looks most
    promising)
- [ ] Refactor the guts of the visualisation, the user should only provide a transition table
- [ ] Make transition tables more robust 
  - [ ] Maybe support functions as well ? 
  - [ ] I want to do something like [wave function collapse](https://en.wikipedia.org/wiki/Wave_function_collapse)
- [ ] Can load images as boards.
- [ ] Deduce some part of the board from an image.
- [ ] Maybe make the board scrollable.
- [ ] Improve method of putting cells on board
  - [ ] Add a 'line' method
  - [ ] Add a 'box' method
