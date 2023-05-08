# automata-engine
A general cellular automata engine implemented in lua using [Love2d](https://love2d.org/) for visualisation

Inspired by [this](https://www.youtube.com/watch?v=ygdPRlSo3Qg)

 
Cellular automata seem like an interesting computational device.
This is also an experiment with the love2d game engine.

## ToDo
- [x] Implemented engine.
- [x] Implemented visualisation.
- [x] Implemented basic interactions(more like controls) with the visualisation.
- [x] Untie refresh rate and board update
- [ ] Add a button to generate just the next itereation
- [ ] Clean up code that constructs ui and all that - make for a cleaner config
- [ ] Add other automata to simulate.
  - [ ] [Brian's Brain](https://en.wikipedia.org/wiki/Brian%27s_Brain)
  - [ ] [Seeds](https://en.wikipedia.org/wiki/Seeds_(cellular_automaton))
  - [ ] [Codd](https://en.wikipedia.org/wiki/Codd%27s_cellular_automaton)
  - [ ] [Day and Night](https://en.wikipedia.org/wiki/Day_and_Night_(cellular_automaton))
  - [ ] [Turmite](https://en.wikipedia.org/wiki/Turmite)
  - [x] [Wireworld](https://en.wikipedia.org/wiki/Wireworld) (most
    promising)
- [ ] Make transition tables more robust 
  - [ ] Maybe support functions as well ? 
  - [x] Wildcard transition states
  - [ ] I want to do something like [wave function collapse](https://en.wikipedia.org/wiki/Wave_function_collapse) Maybe the state can be a function that takes some more parameters besides adjeeicent pieces?
- [ ] Can load images as boards.
- [ ] Deduce some part of the board from an image.
- [ ] Maybe make the board scrollable.
- [ ] Improve method of putting cells on board
  - [ ] Add a 'line' method
  - [ ] Add a 'box' method
- [ ] Transition to images
  - [ ] Add a save as ppm
  - [ ] Add a load from ppm
  - [ ] Can load images as boards.
  - [ ] Deduce some part of the board from an image.
- [x] Reset button
- [x] Buttons to control 'updates per second'
- [x] Buttons to Show Generations

### Game Of Life
<img src="https://github.com/rdpopv/automata-engine/blob/master/.img/GoL-glider.png"  title="Game of life">

### Wireworld
<img src="https://github.com/rdpopv/automata-engine/blob/master/ .img/Wireworld-donut.png"  title="Wireworld">
