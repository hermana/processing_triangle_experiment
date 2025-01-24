 //////////////////////////////// CONSTANTS /////////////////////////////////////////////////////
 
 int GRID_SIZE=12;
 int ROW_SIZE=50;
 int COLUMN_SIZE=50;
 int TRIANGLE_SIZE=45;
 
 ExperimentPhase phase;
 Icon[][] grid;
  //////////////////////////////// ICON CLASS /////////////////////////////////////////////////////
 
class Icon { 
  
   int row;
   int column;
   int rotation;
   color colour;
   boolean isTarget;
  
   Icon(int myRow, int myColumn, int myRotation, color myColour, boolean myIsTarget) {  
     row = myRow;
     column = myColumn;
     rotation = myRotation;
     colour = myColour;
     isTarget = myIsTarget;
  } 
  
  void drawIcon(){
   pushMatrix();
   fill(colour);
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
  fill(0);    
  PFont myFont = createFont("Arial", 32, true); 
  textFont(myFont);
  textAlign(CENTER);
  phase = ExperimentPhase.INSTRUCTIONS;
  grid_setup();
}

void draw() {

  Condition condition = new Condition("Condition 1:", "In the next tasks, click on the triangle \n that is more green than the others.", ManipulationType.COLOUR, 90, 20, 2); 
  background(200);
  switch(phase){
    case INSTRUCTIONS:
      text("Instructions", width/2, height/2);
      text("Click to continue.", width/2, (height/2)+50);
      break;
    case BEFORE_CONDITION: 
      text(condition.name, width/2, height/2);
      text(condition.instructions, width/2, (height/2)+50);
      text("Click to continue.", width/2, (height/2)+200);
      break;
    case BEFORE_TRIAL: 
      text("Trial "+ str(condition.currentTrial) +" of "+ str(condition.numTrials), width/2-10, height/2);
      text("Click to continue.", width/2, (height/2)+150);
      break;
    case TRIAL: 
      background(200);
      fill(255, 204); // default colour
      stroke(0);
      pushMatrix();
      translate(width/4, height/4); //TODO: rename to semantic meaning, used them in grid. 
      rect(-ROW_SIZE, -TRIANGLE_SIZE-COLUMN_SIZE, GRID_SIZE*ROW_SIZE + (ROW_SIZE*2), GRID_SIZE*COLUMN_SIZE + (COLUMN_SIZE*2));
      grid_draw();
      popMatrix();
      break;
    case FINISHED: 
      fill(0);
      text("This trial has finished.", width/2, height/2);
      text("Click to continue.", width/2, (height/2)+150);
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
      if(grid_is_target_clicked()){ 
        phase = ExperimentPhase.FINISHED;
      }
      break;
    case FINISHED: 
      break;
}
}

/////////////////////////////// HELPERS //////////////////////////////////////////////////////////////////

//TODO make grid into a class
void grid_setup() {
  grid = new Icon[GRID_SIZE][GRID_SIZE];
  int targetRow = int(random(GRID_SIZE));
  int targetColumn = int(random(GRID_SIZE));
  for (int row = 0; row < GRID_SIZE; row++) {
    for (int column = 0; column < GRID_SIZE; column++) {
      boolean isTarget = (row == targetRow && column == targetColumn) ? true : false;
      color triangleColour = isTarget ? color(0, 255, 0) : color(255, 255, 255);
      grid[row][column] = new Icon(row, column, 0, triangleColour, isTarget);
    }
  }
}

void grid_draw(){
  for (int row = 0; row < GRID_SIZE; row++) {
    for (int column = 0; column < GRID_SIZE; column++) {
      grid[row][column].drawIcon();
    }
  }
}

boolean grid_is_target_clicked(){
  for (int row = 0; row < GRID_SIZE; row++) {
    for (int column = 0; column < GRID_SIZE; column++) {
      if (mouseX > (row*ROW_SIZE) + width/4 && mouseX < (row*ROW_SIZE) + COLUMN_SIZE + width/4 
          && mouseY > column*COLUMN_SIZE + - ROW_SIZE + height/4 && mouseY < (column*COLUMN_SIZE) + height/4) {
          if(grid[row][column].isTarget){
            return true;
          }
      }
    }
  }
  return false;
}
