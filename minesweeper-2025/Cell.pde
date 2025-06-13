//Code for each tile
class Cell{ //each object is one tile on the board
  int col,row; //col is x, row is y
  boolean flagged, mined, dug, firstTile; //whether the tile is flagged, is mined, and/or is dug up. all are false by default. firstTile tells whether this is the first tile mined. this is used to ensure that the first tile clicked is not a mine
  
  Cell(int tempCol, int tempRow){//constructor
    col = tempCol; //sets col to the inputted value
    row = tempRow; //sets row to the inputted value
    setCellVars(); //sets all the default values
  }
  
  void setCellVars(){//these variables are reset when the game is reset
    flagged=false; //whether the cell is marked with a flag
    mined=false; //whether the cell has a mine under it
    firstTile=false; //whether the cell is the first one mined by the player. this is used to ensure that the first tile clicked is not a mine, or directly next to one, when the tiles are being generated
    dug=false; //whether the cell has been dug up by the player
  }
  
  boolean mousedOver(){ //returns whether the mouse is above the tile
    if(mouseGridX==col && mouseGridY==row){ //checks whether the mouse is within the width and height of the cell in question
      return true; //true
    }
    else{
      return false; //false
    }
  }
  
  int adjacentMinesCount(){
    int adjs = 0; //number of adjacent mines
    for(int a=(col-1);a<=(col+1);a++){    //for each vertical set of 3 (left of the tile, centered on the tile, right of the tile)
      for(int b=(row-1);b<=(row+1);b++){  //for each tile in that set (above the tile, in line with the tile, below the tile)
        if(a>=0 && b>=0 && a<15 && b<15){ //ensures that we don't test anything outside the bounds of the array, which would throw an error
          if(tileArray[a][b].mined==true){  //if the tile is mined
            adjs++; //adds 1 to the counter if there is a mine in the checked tile
          }
        }
      }
    }
    return adjs; //output the number of mines found
  }
  
  int adjacentFlagsCount(){ //counts the number of adjacent flags; used for autoDigUnflagged
    int adjs = 0; //number of adjacent flags
    for(int a=(col-1);a<=(col+1);a++){    //for each vertical set of 3
      for(int b=(row-1);b<=(row+1);b++){  //for each tile in that set
        if((a>=0 && b>=0 && a<15 && b<15) && tileArray[a][b].flagged==true){ //ensures that we don't test anything outside the bounds of the array, which would throw an error
          adjs++; //adds 1 to the counter if there is a flag on the checked tile
        }
      }
    }
    return adjs; //output the number of mines found
  }
  
  boolean nextToFirstTile(){ //checks to see if this tile is next to the first tile the player clicks. if this is the case, the program will not add mines to it
    for(int a=(col-1);a<=(col+1);a++){    //for each vertical set of 3 (left of this tile, centered on this tile, right of this tile)
      for(int b=(row-1);b<=(row+1);b++){  //for each tile in that set (above this tile, in line with this tile, below this tile)
        if(a>-1 && b>-1 &&  a<15 && b<15){ //if the adjacent tile (being checked) is not out of bounds
          if(tileArray[a][b].firstTile==true){ //if the adjacent tile was the first tile
            return true; //true
          }
        }
      }
    }
    return false; //otherwise false
  }
  
  void addMines(){//used in tile generation
    if(mined==false && firstTile==false && nextToFirstTile()==false){ //if the tile does not already have a mine when this function is called, and it was not the first tile selected, or next to the first tile
      mined=true; //make this tile mined
      existingMines++; //increase the variable that tracks the number of mines that were placed
    }
  }
  
  void mayFlag(){//tests to see if the cell will be flagged
    if((flagCount>0||flagged==true) && dug==false){ // this checks to see if the mouse is clicked within the box of the cell. also you can't add a flag if you've run out, only remove them
      flagged = !flagged; //toggles flag
      if(flagged==false){ //if it removes a flag
        flagCount++; //increase the tally of flags that are not placed
      }
      if(flagged==true){ //if it adds a flag
        flagCount--; //decrease the tally of flags that are not placed
      }
    }
  }
  
  void mayDig(){ //tests to see if the cell will be dug
    if(flagged==false){ //this checks to see if the mouse is clicked within the box of the cell. also you can't click it if the box is flagged
      if(gameStarted==false){ //if the game has not started yet
        firstTile=true; //label this as the first tile
      }
      if(dug==false){ //if the tile is not dug yet
        tilesDug++; //increase the tally of tiles dug
        dug = true; //digs up cell if conditions are met
      }
      if(mined==true){ //if cell contained a mine
        gameOver = true; //the game ends, the player loses
      }
    }
  }
  
  void autoDig(){
    for(int a=(col-1);a<=(col+1);a++){    //for each vertical set of 3 (left of the tile, centered on the tile, right of the tile)
      for(int b=(row-1);b<=(row+1);b++){  //for each tile in that set (above the tile, in line with the tile, below the tile)
        if(a>-1 && a<15 && b>-1 && b<15){ //if it is a surrounding tile that is not out of bounds
          if(adjacentMinesCount()==0 && dug==true && tileArray[a][b].dug==false){ //if the middle tile has no adjacent mines, is dug, and the neighbor tile is not dug
            tileArray[a][b].dug=true; //dig the neighbor tile
            tilesDug++; //increase the tally of tiles dug by one
            if(tileArray[a][b].flagged==true){ //if one of the tiles being automatically dug was flagged 
              tileArray[a][b].flagged=false; //removes the flag
              flagCount++; //increases the count
            }
          }
        }
      }
    }
  }
  
  void autoDigUnflagged(){ //when a selected tile is clicked, if the player has flagged the correct number of adjacent mines, it will automatically mine any leftover tiles
    for(int a=(col-1);a<=(col+1);a++){    //for each vertical set of 3 (left of the tile, centered on the tile, right of the tile)
      for(int b=(row-1);b<=(row+1);b++){  //for each tile in that set (above the tile, in line with the tile, below the tile)
        if((a>=0 && b>=0 && a<15 && b<15) && !(a==col && b==row) && tileArray[a][b].flagged==false && tileArray[a][b].dug==false){ //ensures that we don't test anything outside the bounds of the array, which would throw an error
          tileArray[a][b].dug=true; //dig the tile in question
          tilesDug++; //add to the count of tiles dug
          if(tileArray[a][b].mined==true){ //if the tile was mined
            gameOver=true; //game over
          }
        }
      }
    }
  }
  
  void display(){ //displays a single tile
    //displays undug tile v
    noStroke(); // no stroke
    fill(220); //light grey
    rect(col*40,row*40,40,40); //highlight
    fill(110); //dark grey
    triangle(col*40+40,row*40,col*40,row*40+40,col*40+40,row*40+40);//shadow 
    fill(160); //medium grey
    rect(col*40+5,row*40+5,30,30);//main part of undug mine
    if(flagged==true){ //displays flag
      image(pennant,col*40+10,row*40+10); //display the pennant flag
    }
    //displays undug tile ^
    //displays dug tile v
    if(dug==true){ //displays when dug (draws over the "undug" tile)
      fill(200); //grey fill
      rect(col*40,row*40,40,40); //grey rectangle
      fill(0); //black fill
      if(mined==true){ //if the space had a mine
        image(navalmine,col*40+((40-navalmine.width)/2),row*40+((40-navalmine.height)/2)); //display the naval mine icon
      }
      else if(adjacentMinesCount()>0){ //if there are any mines next to the tile
        textFont(numbers); //set font to the numbers font
        switch(adjacentMinesCount()){ //checks to see if adjacentMinesCount is equal to any of the following values
          case 1: fill(color(0,0,200)); break;   //1-blue
          case 2: fill(color(0,200,0)); break;   //2-green
          case 3: fill(color(200,0,0)); break;   //3-red
          case 4: fill(color(0,0,100)); break;   //4-dark blue
          case 5: fill(color(100,0,0)); break;   //5-dark red
          case 6: fill(color(0,150,150)); break; //6-teal
          case 7: fill(color(150,0,150)); break; //7-purple
          case 8: fill(color(50)); break;        //8-grey
        }
        text(adjacentMinesCount(),col*40+13,row*40+32); //displays the number of nearby mines
      }
    }
    //displays dug tile ^
  } 
}
