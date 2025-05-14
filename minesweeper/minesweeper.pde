/*
Minesweeper
13 May 2025
*/

//These variables stay the same, unless there are fundamental changes being made to the game's format.
PFont numbers,sysfont,smallfont,ittybittyfont; //fonts used for tile numbers, game over messages, flag count, and instructions, respectively
int gridWidth=15, gridHeight=15; //determines the number of cells across and down. Static at 15*15. I made it a variable because it will make it easier to generate larger/smaller boards in the future with minimal tweaks to code.
int mineCount = 40; //the total number of mines on the board. for a 15*15 board, should be 40. 

//These variables change over time, and are reset by setGlobalVars() when the game restarts.
int existingMines, tilesDug, flagCount; //existingMines counts how many mines have been placed. it starts at 0, then increases to 40 as the board is generated. tilesDug gives the number of tiles uncovered. flagCount is the number of flags the player has to mark; the same as the number of mines. it decreases as the player marks mines
int timer; //used to keep score
boolean gameStarted, gameOver, gameWon, analogMode=false; //gameStarted becomes true when the player digs the first cell; used to signal board generation. gameOver becomes true when the player hits a mine and loses; gameWon becomes true when the player hits all the tiles

int mouseGridX,mouseGridY; //used to track which tile the mouse is above

//This creates a 2d array for the grid. Each item in the array represents a cell of the Minesweeper board.
Cell[][] tileArray = new Cell[gridWidth][gridHeight]; //creates a two-dimensional Array, tileArray, made up of cell objects, one for each item in the grid

void setGlobalVars(){//is used when the game begins, and when it resets
  gameStarted = false; //becomes true when the player digs the first cell
  gameOver = false; //becomes true when the player hits a mine
  existingMines=0; //existingMines counts how many mines have been placed. it starts at 0, then increases to 40 as the board is generated.
  tilesDug=0; //counts the number of tiles uncovered
  flagCount = mineCount; //sets the number of flags equal to the number of mines
  timer = 0; //sets timer to 0
}


void setup(){
  size(600,700); //board size (x should be equal to gridWidth*40, y should be equal to gridWidth*40+100)
  background(255); //background color. can be whatever as long as it has enough contrast with black text
  numbers = createFont("Krungthep",32); //creates the font for numbers
  sysfont = createFont("Krungthep",42); //creates the font for system messages
  smallfont = createFont("Krungthep",20); //creates the font for information in the menu bar
  ittybittyfont = createFont("Krungthep",14); //creates the font that provides instructions
  setGlobalVars(); //sets the global variables to their original state
  for(int i=0; i<15; i+=1){//for each column
    for(int j=0; j<15; j+=1){//for each row in that column
      tileArray[i][j] = new Cell(i,j);//initializes a tile
    }
  }
}


void draw(){
  background(255); //redraw background
  for(int l=0; l<gridWidth; l++){//for each column
    for(int m=0; m<gridHeight; m++){//for each row in that column
      if(gameOver==false && gameWon==false){ //once you hit a mine, it's game over and you can't dig anymore
        if(gameStarted==true){
          tileArray[l][m].autoDig(); //automatically digs any tiles adjacent to tiles that have 0 adjacent mines
        }
        tileArray[l][m].mayFlag(); //checks if tiles are being flagged (or unflagged)  
        tileArray[l][m].mayDig(); //checks if tiles are being dug
      }
      tileArray[l][m].display(); //displays tiles
    }
  }
  
  if(gameOver==true){ //if you hit a mine and gameOver triggers
    endGameMessage("Game Over",180,color(255,0,0)); //provides a game over message
}
  
  if(tilesDug==((gridWidth*gridHeight)-mineCount) && gameOver==false){ //if you win (dig up all the tiles)
    gameWon=true; //indicate the game is won; this may be used later for a high score tracker
    endGameMessage("You Won!",197,color(0,255,0)); //provides a game won message    
}
  
  //displays current game info
  if(gameStarted==true && gameOver==false && gameWon==false){ //implements a timer 
    timer++; //this keeps track of the time while the game is active (from when the player clicks the first mine to when the player wins or loses)
    seconds=timer/60; //seconds is based on the timer variable, which resets when the game resets
  }
  if(analogMode==false){
    fill(180); //grey fill
    rect(0,600,120,200); //rectangle to divide the menu into sections
    fill(255,0,0); //red
    triangle(25,620,25,635,43,627); //red triangle pennant
    fill(0); //black
    rect(25,620,3,20); //black flagpole
    textFont(smallfont); //sets text to small
    text(flagCount,50,640); //displays flag count
    textFont(ittybittyfont); //displays instructions
    text("Left click to dig; Right click/Space to add or remove a flag. \nTime: " + (timer/60) + "\nPress 'm' to switch modes.",140,636); //instructions for gameplay
    button(20,650,80,40, "Restart"); //dosplays the restart button
  }
  if(analogMode==true){
    segmentDisplay(seconds,14,614,8,color(0)); //displays the timer
    segmentDisplay(flagCount,458,614,8,color(0)); //displays the flag count
  }
}

void mousePressed(){
  if(gameStarted==false && gameWon==false && mouseInBounds()==true){ //if mouse is within the grid
    tileArray[int(mouseX/40)][int(mouseY/40)].mayDig(); //digs the currently hovered-over tile
    while(existingMines<mineCount){ //until there are enough mines
      tileArray[int(random(0,15))][int(random(0,15))].addMines(); //generates mines
    }
    gameStarted=true;//allows the game to begin
  }
  if(mouseInBounds()==true && tileArray[int(mouseX/40)][int(mouseY/40)].dug==true && (tileArray[int(mouseX/40)][int(mouseY/40)].adjacentMinesCount()==tileArray[int(mouseX/40)][int(mouseY/40)].adjacentFlagsCount())){
    tileArray[int(mouseX/40)][int(mouseY/40)].autoDigUnflagged();
  }
  if(mouseX>=20 && mouseY>=650 && mouseX<20+80 && mouseY<650+40){ //the reset button
    restart(); //restarts the game
  }
}

void keyPressed(){
  if(key=='m'){ //on the m keypress
    analogMode=!analogMode; //toggles analogMode, a more streamlined (and cooler-looking) version of the interface
  }
}


boolean mouseInBounds(){//tests if the mouse is within the bounds of the grid
  if(mouseX>=0 && mouseX<gridWidth*40 && mouseY>=0 && mouseY<gridHeight*40){ //if the mouse is within the grid
    return true; //true
  }
  else{
    return false; //false
  }
}

void button(int x, int y, int w, int h, String m){ //used to draw buttons with cool tile-style shading
  fill(220); //light grey
  rect(x,y,w,h); //highlight
  fill(110); //dark grey
  rect(x+5,y+5,w-5,h-5);//shadow
  triangle(x+w-5,y+5,x+w,y+5,x+w,y);//shadow corner
  triangle(x,y+h,x+5,y+h,x+5,y+h-5);//shadow corner    
  fill(160); //medium grey
  rect(x+5,y+5,w-10,h-10);//main part of undug mine
  fill(0); //button label
  textFont(ittybittyfont); //button label
  text(m,x+10,y+(h/2)+6);//places text 
}
