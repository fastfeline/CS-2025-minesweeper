# CS-2025-minesweeper
Updated 13 June 2025
Minesweeper game for a computer science course. Written for Processing (processing.org). 

(This project was originally created as a final for a computer science class; this is why almost every line is commented. And why this README is more thorough than usual.)

  This project is a version of the classic computer game Minesweeper, in which the player is tasked with locating mines on a board of tiles whose contents are concealed. The player digs up tiles by clicking on them, revealing either a blank tile, a mine, or a number indicating the number of adjacent mines. The player can use this information to deduce where the mines are. To win, the player must reveal all tiles except the mined tiles.

  Each clickable “cell” is an object, with various processes that run when the player left-clicks, right-clicks, or presses space while hovering on the tile. Left-click will dig up the tile, while right click or hover+space will flag the tile (marking it as containing a mine. Each Cell object contains code to display as either hidden, or revealed to contain a number, mine, or blank space. For ease of gameplay, each also contains code to automatically dig adjacent tiles (if no adjacent tiles are mined), and to manually dig adjacent tiles (when the tile is clicked and the player has marked the correct number of mines near the tile).

The game also contains the following:
  * A timer that tracks how long it takes the player to complete a set round; this is akin to a score, with a lower time being a better score
  * Code that scores the best (lowest) scores between games
  * The ability to place flags on tiles to mark locations where mines are thought to be
  * A counter to track the number of placed flags, letting the player know how many mines they still need to find
  * Buttons to toggle the information box displaying the rules of the game and restart the game. These can also be done with the ‘i’ and ENTER keys, respectively
  * Code for seven-segment style displays to display numbers.

The following sources were helpful:
https://processing.org/reference/ for general processing documentation.
https://coderanch.com/t/628589/java/create-objects-loop for creating arrays of objects using loops.
https://forum.processing.org/two/discussion/27604/find-image-dimensions-when-loading-image.html for finding the dimensions of images.
A.L.’s Tetris project for the method of storing high scores using PrintWriter
JustBlebs (SylviaIsTired)’s various helpful suggestions, especially telling me to use the switch() function.
