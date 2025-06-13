/*
Minesweeper
13 June 2025
A version of the classic computer game Minesweeper, a logic game where the player must uncover tiles without clicking on a mine.
*/

//These variables stay the same, unless there are fundamental changes being made to the game's format.
PFont numbers,sysfont,smallfont,ittybittyfont; //fonts used for tile numbers, game over messages, flag count, and instructions, respectively
int gridWidth=15, gridHeight=15; //determines the number of cells across and down. Static at 15*15. I made it a variable because it will make it easier to generate larger/smaller boards in the future with minimal tweaks to code.
int mineCount = 40; //the total number of mines on the board. for a 15*15 board, should be 40. 
PImage pennant, hourglass, navalmine; //images for the flag and hourglass icons

//These variables change over time, and are reset by setGlobalVars() when the game restarts.
int existingMines, tilesDug, flagCount; //existingMines counts how many mines have been placed. it starts at 0, then increases to 40 as the board is generated. tilesDug gives the number of tiles uncovered. flagCount is the number of flags the player has to mark; the same as the number of mines. it decreases as the player marks mines
int timer; //used to keep score
boolean gameStarted, gameOver, gameWon; //gameStarted becomes true when the player digs the first cell; used to signal board generation. gameOver becomes true when the player hits a mine and loses; gameWon becomes true when the player hits all the tiles

//These variables do their own thing
int mouseGridX,mouseGridY; //used to track which tile the mouse is above
int bestScore; //used to store the shortest times since the game started
boolean showInfo=true; //showInfo toggles the display of instructions

//This creates a 2d array for the grid. Each item in the array represents a cell of the Minesweeper board.
Cell[][] tileArray = new Cell[gridWidth][gridHeight]; //creates a two-dimensional Array, tileArray, made up of cell objects, one for each item in the grid

void setGlobalVars(){//is used when the game begins, and when it resets
  gameStarted = false; //becomes true when the player digs the first cell
  gameOver = false; //becomes true when the player hits a mine
  gameWon = false; //becomes true when the game is won
  existingMines=0; //existingMines counts how many mines have been placed. it starts at 0, then increases to 40 as the board is generated.
  tilesDug=0; //counts the number of tiles uncovered
  flagCount = mineCount; //sets the number of flags equal to the number of mines
  timer = 0; //sets timer to 0
}

void setup(){
  size(600,700); //board size (x should be equal to gridWidth*40, y should be equal to gridWidth*40+100)
  background(255); //background color. can be whatever as long as it has enough contrast with black text
  numbers = loadFont("Krungthep-32.vlw"); //creates the font for numbers
  sysfont = loadFont("Krungthep-42.vlw"); //creates the font for system messages
  smallfont = loadFont("Krungthep-20.vlw"); //creates the font for information in the menu bar
  ittybittyfont = loadFont("ArialMT-14.vlw"); //creates the font that provides instructions
  pennant = loadImage("flag.png"); //pixel art flag I made
  hourglass = loadImage("hourglass.png"); //pixel art hourglass I made
  navalmine = loadImage("mine26.png"); //pixel art naval mine I made
  setGlobalVars(); //sets the global variables to their original state
  for(int i=0; i<15; i+=1){//for each column
    for(int j=0; j<15; j+=1){//for each row in that column
      tileArray[i][j] = new Cell(i,j);//initializes a tile
    }
  }
}


void draw(){
  /////clears canvas and updates variables/////
  background(160); //redraw background
  seconds=min(timer/60,999); //seconds is based on the timer variable, which resets when the game resets. it caps out at 999 to avoid display overflows
  mouseGridX=int(mouseX/40); //updates mouse grid x coordinate
  mouseGridY=int(mouseY/40); //updates mouse grid y coordinate
  /////runs through tiles and updates them/////
  for(int l=0; l<gridWidth; l++){//for each column
    for(int m=0; m<gridHeight; m++){//for each row in that column
      if(gameOver==false && gameWon==false && gameStarted==true){ //this code only runs while the game is active; once you hit a mine, it's game over and you can't dig anymore
        tileArray[l][m].autoDig(); //automatically digs any tiles adjacent to tiles that have 0 adjacent mines
      }
      tileArray[l][m].display(); //displays tiles
    }
  }
  /////tests game end states/////
  if(gameOver==true){ //if you hit a mine and gameOver triggers
    endGameMessage("Game Over",180,color(255,0,0)); //provides a game over message
  }
  if(tilesDug==((gridWidth*gridHeight)-mineCount) && gameOver==false){ //if you win (dig up all the tiles)
    if(gameWon==false){
      checkScores(seconds); //check for high score (only do this once, as soon as the win state triggers
    }
    gameWon=true; //indicate the game is won; this may be used later for a high score tracker
    endGameMessage("You Won!",197,color(0,255,0)); //provides a game won message    
  }
  /////displays current game info/////
  if(gameStarted==true && gameOver==false && gameWon==false){ //implements a timer 
    timer++; //this keeps track of the time while the game is active (from when the player clicks the first mine to when the player wins or loses)
  }
  /////displays info/////
  fill(0); //black text
  textFont(smallfont); //sets text to small
  image(pennant,25,617); //displays little pixel art flag
  segmentDisplay(flagCount,52,610,4,0); //displays flag count on 7 segment display
  image(hourglass,22,662); //displays little pixel art hourglass
  segmentDisplay(seconds,52,654,4,0); //displays time spent this round
  stroke(100); //grey outline for display
  rect(445,608,140,84); //draw rectangle background for display
  noStroke(); //stop drawing outlines
  fill(255); //white color for text
  textFont(ittybittyfont); //small text to display scores
  text("Best times:\n" + scoreVals[0] + "\n" + scoreVals[1] + "\n" + scoreVals[2], 455, 625); //displays high scores
  if(showInfo==true){ //when the info box is open
    fill(160); //grey
    rect(160,160,280,320); //display window
    fill(0); //black
    textFont(numbers); //larger font for heading
    text("Minesweeper",170,202); //heading
    textFont(ittybittyfont); //smaller font for text
    text(line1+line2+line3,170,226); //concatenates and prints the instructions
    stroke(100); //grey stroke
    fill(180); //lighter grey fill
    rect(413,164,20,20); //rectangle to exit
    textFont(smallfont); //font for x
    fill(100); //dark grey fill
    text("x",417,180); // x for x box
    noStroke(); //back to noStroke 
  }
  /////Displays buttons at bottom of screen/////
  button(220,640,45,45,"  i"); //i button for showing/hiding info
  button(275,640,90,45,"restart"); //restart button
  if(mousePressed==true){ //provides a little circle for effect when the mouse is clicked
    fill(255); //white fill
    circle(mouseX,mouseY,10); //circle
  }
}

void mousePressed(){
  if(mouseInBounds()==true && showInfo==false){ //actions within the grid (clicking tiles)
    if(mouseButton==LEFT){ //left click digs a tile
      //when a selected tile is clicked, if the player has flagged the correct number of adjacent mines, it will automatically mine any leftover tiles
      if(tileArray[mouseGridX][mouseGridY].dug==true && (tileArray[mouseGridX][mouseGridY].adjacentMinesCount()==tileArray[mouseGridX][mouseGridY].adjacentFlagsCount())){ //checks if the number of adjacent flagged tiles is equal to the number of adjacent mines
        tileArray[mouseGridX][mouseGridY].autoDigUnflagged(); //if so, digs adjacent unflagged tiles when the key is pressed
      }
      else{
        tileArray[mouseGridX][mouseGridY].mayDig(); //digs the currently hovered-over tile
      }
      if(gameStarted==false && gameWon==false){ //if the game hasn't started and grid hasn't been generated, generate the mines
        while(existingMines<mineCount){ //until there are enough mines
          tileArray[int(random(0,15))][int(random(0,15))].addMines(); //generates mines
        }
        gameStarted=true;//allows the game to begin
      }
    }
    if(mouseButton==RIGHT){ //right click flags a tile
      tileArray[mouseGridX][mouseGridY].mayFlag(); //flags the selected tile
    }
  }
  /////x on the info box/////
  if(showInfo==true && mouseX>=413 && mouseX<433 && mouseY>=164 && mouseY<184){ //if showInfo is active and the mouse is in the info box
    showInfo=false; //toggles showing info                                     
  }
  /////Buttons at bottom of screen/////
  if(mouseX>=220 && mouseX<265 && mouseY>=640 && mouseY<685){ //"i" button
    showInfo=!showInfo; //toggles info
  }
  if(mouseX>=275 && mouseX<365 && mouseY>=640 && mouseY<685){//"restart" button
    restart(); //restarts game
  }
}

void keyPressed(){
  switch(key){ //checks to see whether the most recent key is any of the following
    case ' ': 
      if(mouseInBounds()==true){ //if the mouse is within bounds
        tileArray[mouseGridX][mouseGridY].mayFlag(); //flags the current tile
      }
      break;
    case 'i':
      showInfo=!showInfo; //toggles the instruction box
      break;
    case ENTER:
      restart(); //restarts game
      break;
  }
}

boolean mouseInBounds(){//tests if the mouse is within the bounds of the grid
  if(mouseGridX>=0 && mouseGridX<gridWidth && mouseGridY>=0 && mouseGridY<gridHeight){ //if the mouse is within the grid
    return true; //true
  }
  else{
    return false; //false
  }
}

void button(int x, int y, int w, int h, String m){ //used to draw buttons with cool tile-style shading
  boolean hovered=false; //used to detect whether the button is hovered over, to create a pressing effect
  if(mouseX>=x && mouseX<x+w && mouseY>=y && mouseY<y+h){ //bounds of the button
    hovered=true; //the mouse is over the button
  }
  fill(220); //light grey
  if(hovered==true){
    fill(110); //highlight becomes shadow (to indicate the button being depressed)
  }
  rect(x,y,w,h); //highlight
  fill(110); //dark grey
  if(hovered==true){
    fill(220); //shadow becomes highlight (to indicate the button being depressed)
  }
  rect(x+5,y+5,w-5,h-5);//shadow
  triangle(x+w-5,y+5,x+w,y+5,x+w,y);//shadow corner
  triangle(x,y+h,x+5,y+h,x+5,y+h-5);//shadow corner    
  fill(160); //medium grey
  if(hovered==true){ //if the button is hovered over
    fill(140);//darker color (to indicate the button being depressed
  }
  rect(x+5,y+5,w-10,h-10);//main part of undug mine
  fill(0); //button label
  textFont(smallfont); //button label
  text(m,x+5,y+(h/2)+7);//places text 
}
