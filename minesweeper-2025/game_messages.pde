//Code for instructions and endgame

void restart(){ //runs when the game is reset
  setGlobalVars(); //resets global variables
  for(int l=0; l<gridWidth; l++){//for each columnn
    for(int m=0; m<gridHeight; m++){//for each row in that column
      tileArray[l][m].setCellVars(); //sets the cell variables back to their original state
    }
  }
}

void endGameMessage(String message, int textx, color c){ //displays endgame message
    fill(160); //grey
    rect(160,300-60,280,160); //display window
    fill(c); //red or green depending on lose or win
    textFont(sysfont); //system text
    text(message,textx,300); //says game over or you win
    fill(0); //button label
    textFont(smallfont); //info font
    text("Press ENTER to restart",182,360); //text
}

//instructions for game (easier to edit and keep track of when they're stored down here)
String line1 = "Welcome to Minesweeper! \nThe objective of the game is to dig up all \nthe tiles, except the ones containing mines. \nOnce dug, tiles will show the number of \nadjacent mines as either a blank tile (0) or \na number from 1 to 8.\n";
String line2 = "Left click to dig a tile. \nRight click, or mouse over + space, to flag \na tile. Flags can be used to mark mines.\n";
String line3 = "Press i to show/hide instructions.\nPress m to toggle analog mode.\nPress enter to restart at any time.\nYou can also do this using the buttons at \nthe bottom of the screen.";
