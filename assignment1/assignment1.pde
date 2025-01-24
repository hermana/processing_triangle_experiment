 //////////////////////////////// CONSTANTS /////////////////////////////////////////////////////
 
 int GRID_SIZE=12;
 int ROW_SIZE=50;
 int COLUMN_SIZE=50;
 int TRIANGLE_SIZE=45;
 
 ExperimentPhase phase;
 
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
    String instructions;
    ManipulationType manipulationType;
    int maxRotation;
    int maxColour; // should this be an int?
    //POSSIBLY A SEPERATE VARIABLE: the increase in the amount of rotation or colour that should be applied to the target icon (beyond the baseline)
    int numTrials;
    int currentTrial;
    int totalTime;
    int totalSuccessfulTrials;
    int totalErrorTrials;
    
    Condition(String cName, String cInstructions, ManipulationType cManipulationType, int cMaxRotation, int cMaxColour, int cNumTrials){
      name = cName;
      instructions = cInstructions;
      manipulationType = cManipulationType;
      maxRotation = cMaxRotation;
      maxColour = cMaxColour;
      numTrials = cNumTrials;
      currentTrial = 1;
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
  PFont myFont = createFont("Arial", 32, true); 
  textFont(myFont);
  phase = ExperimentPhase.INSTRUCTIONS;

}

void draw() {

  Condition condition = new Condition("Condition 1:", "In the next tasks, click on the triangle \n that is more green than the others.", ManipulationType.COLOUR, 90, 20, 2);
  // TODO: add a switch statement to track which phase we are in, in mousepressed as well 
  background(200);
  switch(phase){
    case INSTRUCTIONS:
      fill(0);
      textAlign(CENTER); //FIXME: can this and the fill be everywhere
      text("Instructions", (width/2), height/2);
      text("Click to continue.", (width/2), (height/2)+50);
      break;
    case BEFORE_CONDITION: 
      text(condition.name, (width/2), height/2);
      text(condition.instructions, (width/2), (height/2)+50);
      text("Click to continue.", (width/2), (height/2)+200);
      break;
    case BEFORE_TRIAL: 
      text("Trial "+ str(condition.currentTrial) +" of "+ str(condition.numTrials), width/2-10, height/2);
      text("Click to continue.", (width/2), (height/2)+150);
      break;
    case TRIAL: 
      background(200);
      fill(255, 204); // FIXME: do i need this
      stroke(0);
      pushMatrix();
      translate(width/4, height/4);
      rect(-ROW_SIZE, -TRIANGLE_SIZE-COLUMN_SIZE, GRID_SIZE*ROW_SIZE + (ROW_SIZE*2), GRID_SIZE*COLUMN_SIZE + (COLUMN_SIZE*2));
      grid(GRID_SIZE, GRID_SIZE);
      popMatrix();
      break;
    case FINISHED: 
      fill(0);
      text("This trial has finished.", width/2, height/2);
      text("Click to continue.", (width/2), (height/2)+150);
      break;
}
}


void mouseClicked() {
  switch(phase){
    case INSTRUCTIONS:
      phase = ExperimentPhase.BEFORE_CONDITION;
      break;
    case BEFORE_CONDITION: 
      phase = ExperimentPhase.BEFORE_TRIAL;
      break;
    case BEFORE_TRIAL: 
      phase = ExperimentPhase.TRIAL;
      break;
    case TRIAL: 
      phase = ExperimentPhase.FINISHED;
      break;
    case FINISHED: 
      print("mouse clicked!");
      break;
}
}

/////////////////////////////// HELPERS //////////////////////////////////////////////////////////////////

void grid(int rows, int columns) {
  for (int row = 0; row < rows; row++) {
    for (int column = 0; column < columns; column++) {
      Icon icon = new Icon(row, column, 0);
      icon.drawIcon();
    }
  }
}
