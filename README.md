## AI-Project-Mac-Pan

AI project for ICS 175.  Create an AI that plays a non-deterministic version of PacMan

DEPENDENCIES: 
 - Java Runtime Environment 1.7 or higher
 - A fast machine.  No machine is fast enough.

TO RUN:
 - Windows / Apple: Run "PacDaddyEngine.jar"
 - Linux: On some machines you may have to execute the "run.sh" script from the command line. 

BUGS:
 - Wall shuffling does not properly shuffle pellets after (reloading / level up / death).

OTHER ISSUES:
 - Pacman AI is currently much too slow to perform adequately at normal game speed.  Recommended to lower the game update speed.

CONTROLS:

| KEYS          | DESCRIPTION                                                    |
| ------------- | -------------------------------------------------------------- |
| ARROW KEYS    | Move Pacman.  Pacman's AI typically takes supervisory control. |
| ENTER         | Restart game when lives reach 0                                |
| R             | Reload the game features                                       |
| Q / ESC       | Quit the game                                                  |
| P             | Pause the game update loop.                                    |
| 1 / 2         | Change number of lives                                         |
| 3 / 4         | Change the game speed, in updates per second (UPS)             |
| 5 / 6         | Change the render speed, in frames per second (FPS)            |
| 7 / 8         | Change the level                                               |
| 9             | Toggle Wall Shuffling                                          |
| 0             | Toggle Player AI                                               |

#### Reference
- [PacDaddy Engine](https://github.com/misterdustinface/PacDaddy)
- [Feature Loader Engine](https://github.com/misterdustinface/FeatureLoader)
