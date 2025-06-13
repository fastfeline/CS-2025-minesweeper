//Thanks for A.L. for this method of storing scores using PrintWriter, from their Tetris project
PrintWriter pw; //creates a PrintWriter object

void checkScores(int time){ //script used to check and score new high scores that runs when the game is won
  if(time<=scoreVals[0]){       //if the score is less (better) than the existing first place score
    scoreVals[2]=scoreVals[1]; //shifts the second place score to third
    scoreVals[1]=scoreVals[0]; //shifts the first place score to second
    scoreVals[0]=time;         //replaces the first place score with the current score
  }
  else if(time<=scoreVals[1]){  //if the score is less (better) than the existing second place score
    scoreVals[2]=scoreVals[1]; //shifts the second place score to third
    scoreVals[1]=time;         //replaces the second place score with the current score
  }
  else if(time<=scoreVals[2]){  //if the score is less (better) than the existing third place score
    scoreVals[2]=time;         //replaces the third place score with the current score
  }
  pw = createWriter("scoreArray.pde"); //creates pde file for high scores
  pw.println("int[] scoreVals = {" + scoreVals[0] +"," + scoreVals[1] + "," + scoreVals[2] + "};"); //prints the array to the PDE file
  pw.flush(); //writes remaining data to the file
}
