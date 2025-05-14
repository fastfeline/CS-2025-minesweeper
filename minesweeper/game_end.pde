void endGameMessage(String message, int textx, color c){
    fill(160);
    rect(160,300-60,280,160);
    fill(c); //red
    textFont(sysfont); //system text
    text(message,textx,300); //says game over
    fill(0); //button label
    textFont(smallfont); //info font
    text("Press ENTER to restart",182,360); //text
    if(keyPressed==true && key==ENTER/*mouseX>=212 && mouseX<388 && mouseY>=326 && mouseY<378 && mousePressed==true*/){ //if you click the button
      restart(); //restarts game
    }
}

void restart(){
  setGlobalVars();
  for(int l=0; l<gridWidth; l++){//for each columnn
    for(int m=0; m<gridHeight; m++){//for each row in that column
      tileArray[l][m].setCellVars(); //sets the cell variables back to their original state
    }
  }
}
