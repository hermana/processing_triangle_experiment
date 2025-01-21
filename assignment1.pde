 //////////////////////////////// CONSTANTS /////////////////////////////////////////////////////
 
 int GRID_SIZE=12;
 int ROW_SIZE=50;
 int COLUMN_SIZE=50;
 int TRIANGLE_SIZE=45;
 
  //////////////////////////////// ICON CLASS /////////////////////////////////////////////////////
 
class Icon { 
  
   int row;
   int column;
   int rotation;
  
   Icon(int myRow, int myColumn, int myRotation) {  
     row = myRow;
     column = myColumn;
     rotation = myRotation;

  } 
  
  void drawIcon(){
   pushMatrix();
   // ROTATE here
   translate(row*ROW_SIZE, column*COLUMN_SIZE);
   triangle(TRIANGLE_SIZE/2, -TRIANGLE_SIZE, TRIANGLE_SIZE, 0, 0, 0);
   line(TRIANGLE_SIZE/2, -TRIANGLE_SIZE, TRIANGLE_SIZE/2, 0);
   popMatrix();
  }

} 

  //////////////////////////////// CONDITION CLASS /////////////////////////////////////////////////////
  
  class Condition {
  
    String name;
    ManipulationType manipulationType;
    int maxRotation;
    int maxColour; // should this be an int?
    //POSSIBLY A SEPERATE VARIABLE: the increase in the amount of rotation or colour that should be applied to the target icon (beyond the baseline)
    int numTrials;
    int totalTime;
    int totalSuccessfulTrials;
    int totalErrorTrials;
    
    Condition(String cName, ManipulationType cManipulationType, int cMaxRotation, int cMaxColour, int cNumTrials, int cTotalTime, int cNumSuccessfulTrials, int cTotalErrorTrials){
      name = cName;
      manipulationType = cManipulationType;
      maxRotation = cMaxRotation;
      maxColour = cMaxColour;
      numTrials = cNumTrials;
      totalTime = cTotalTime; //should this just start at zero? and is there an appropriate data type for it?
      totalSuccessfulTrials = cNumSuccessfulTrials;
      totalErrorTrials = cTotalErrorTrials;
      
    }
  
  }
  

 ///////////////////////////////// ENUMS ///////////////////////////////////////////////////
 
 
  enum ExperimentPhase {
    INSTRUCTIONS,
    BEFORE_CONDITION,
    BEFORE_TRIAL, 
    TRIAL, 
    FINISHED
  };
 
  enum ManipulationType {
    COLOUR, 
    ROTATION
  }
 
  //////////////////////////////// SETUP + MAIN DRAW FUNCTIONS /////////////////////////////////////////////////////
 
void setup() {
  size(1080, 1080); 
  stroke(153);

}

void draw() {
  // TODO: add a switch statement to track which phase we are in, in mousepressed as well 
  ExperimentPhase phase = ExperimentPhase.INSTRUCTIONS;
  background(51); 
  fill(255, 204);
  stroke(0);
  pushMatrix();
  translate(width/4, height/4);
  rect(-ROW_SIZE, -TRIANGLE_SIZE-COLUMN_SIZE, GRID_SIZE*ROW_SIZE + (ROW_SIZE*2), GRID_SIZE*COLUMN_SIZE + (COLUMN_SIZE*2));
  grid(GRID_SIZE, GRID_SIZE);
  popMatrix();
}

void grid(int rows, int columns) {
  for (int row = 0; row < rows; row++) {
    for (int column = 0; column < columns; column++) {
      Icon icon = new Icon(row, column, 0);
      icon.drawIcon();
    }
  }
}
