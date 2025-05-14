/* 
Code for seven-segment display style numbers
*/

int seconds; //seconds elapsed in game; directly tied to the timer variable

void segmentDisplay(int displayVal, int x,int y, int size, color bgColor){ //used to track elapsed time in a round, and display that time using a seven segment display
  fill(0);
  rect(x,y,size*16,size*9);//creates a background for the timer
  sevenSegment(x+size,y+size,size,int(displayVal/100), bgColor); //hundreds digit
  sevenSegment(x+(size*6),y+size,size,int((displayVal/10)%10), bgColor); //tens digit
  sevenSegment(x+(size*11),y+size,size,int(displayVal%10), bgColor); //ones digit
}

void checkSegment(int[] list, int checkNumber){ //this code sees to check if a tested number is within an array of numbers; it is a companion to sevenSegment
  fill(40); //this is the color used when segments are "dark"
  for(int i=0;i<list.length;i++){ //for each number in the array, it checks if the tested number is that number
    if(list[i]==checkNumber){     
      fill(255); //if it is in the array, the segment "lights up"
    }
  }
}

void sevenSegment(int x, int y, int size, int number, color bg){
  stroke(bg);//the stroke is used to create outlines, making the shapes look like separate segments
  strokeWeight(2); //creates outlines and spaces between segments; this can be changed for different styles
  int[] intsa= {2,3,4,5,6,8,9}; //numbers that include a middle segment
  checkSegment(intsa, number); //checks to see if that segment should be lit up
  rect(x,y+(3*size),4*size,size); //middle segment
  int[] intsb= {0,2,3,5,6,7,8,9}; //numbers that include a top segment
  checkSegment(intsb, number); //checks to see if that segment should be lit up
  quad(x,y,x+size,y+size,x+(3*size),y+size,x+(4*size),y); //top segment
  int[] intsc= {0,4,5,6,8,9}; //numbers that include a top left segment
  checkSegment(intsc, number); //checks to see if that segment should be lit up
  quad(x,y,x+size,y+size,x+size,y+(3*size),x,y+(4*size)); //top left segment
  int[] intsd= {0,1,2,3,4,7,8,9};//numbers that include a top right segment
  checkSegment(intsd, number); //checks to see if that segment should be lit up
  quad(x+(4*size),y,x+(3*size),y+size,x+(3*size),y+(3*size),x+(4*size),y+(4*size)); //top right segment
  int[] intse= {0,2,6,8}; //numbers that include a bottom left segment
  checkSegment(intse, number); //checks to see if that segment should be lit up
  quad(x,y+(3*size),x+size,y+(4*size),x+size,y+(6*size),x,y+(7*size)); //bottom left segment
  int[] intsf= {0,1,3,4,5,6,7,8,9};//numbers that include a bottom right segment
  checkSegment(intsf, number); //checks to see if that segment should be lit up
  quad(x+(4*size),y+(3*size),x+(3*size),y+(4*size),x+(3*size),y+(6*size),x+(4*size),y+(7*size));//bottom right segment
  int[] intsg= {0,2,3,5,6,8,9};//numbers that include a bottom segment
  checkSegment(intsg, number); //checks to see if that segment should be lit up
  quad(x,y+(7*size),x+size,y+(6*size),x+(3*size),y+(6*size),x+(4*size),y+(7*size));//bottom segment
  fill(bg);//background-colored fill to clean up the edges a bit
  triangle(x,y+(3*size),x+(0.5*size),y+(3.5*size),x,y+(4*size)); //middle left triangle, cutting off the corners of two rhombi
  triangle(x+(4*size),y+(3*size),x+(3.5*size),y+(3.5*size),x+(4*size),y+(4*size)); //middle right triangle, cutting off the corners of two rhombi
}
