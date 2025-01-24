 //////////////////////////////// CONSTANTS /////////////////////////////////////////////////////
 
 int GRID_SIZE=12;
 int ROW_SIZE=50;
 int COLUMN_SIZE=50;
 int TRIANGLE_SIZE=45;
 
 ExperimentPhase phase;
 Icon[][] grid;
 Condition condition;
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
    int targetColourIncrease;
    int targetRotationIncrease;
    //POSSIBLY A SEPERATE VARIABLE: the increase in the amount of rotation or colour that should be applied to the target icon (beyond the baseline)
    int numTrials;
    int currentTrial;
    int totalTime;
    int totalSuccessfulTrials;
    int totalErrorTrials;
    
    void update_current_trial(){
      currentTrial+=1;
    }
    
    Condition(String cName, String cInstructions, ManipulationType cManipulationType, int cMaxRotation, int cMaxColour, int cNumTrials, int cTargetColourIncrease, int cTargetRotationIncrease){
      name = cName;
      instructions = cInstructions;
      manipulationType = cManipulationType;
      maxRotation = cMaxRotation;
      maxColour = cMaxColour;
      targetColourIncrease = cTargetColourIncrease;
      targetRotationIncrease = cTargetRotationIncrease;
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
  
  condition = new Condition("Condition 1:", "In the next tasks, click on the triangle \n that is more green than the others.", 
                                        ManipulationType.COLOUR, 0, 50, 10, 255, 45); //FIXME: basecolour 50 is too low apparently
  
  phase = ExperimentPhase.INSTRUCTIONS;
  grid_setup(condition);
}

void draw() {
  
  
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
      fill(0);
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
       if(condition.currentTrial >= condition.numTrials+1){
         phase = ExperimentPhase.FINISHED;
       }else{
         phase = ExperimentPhase.BEFORE_TRIAL;
       }
      }
      break;
    case FINISHED: 
      break;
}
}

/////////////////////////////// HELPERS //////////////////////////////////////////////////////////////////

//TODO make grid into a class
void grid_setup(Condition condition) {
  grid = new Icon[GRID_SIZE][GRID_SIZE];
  int targetRow = int(random(GRID_SIZE));
  int targetColumn = int(random(GRID_SIZE));
  for (int row = 0; row < GRID_SIZE; row++) {
    for (int column = 0; column < GRID_SIZE; column++) {
      boolean isTarget = (row == targetRow && column == targetColumn) ? true : false;
      int targetColourParam = condition.maxColour + condition.targetColourIncrease <= 255 ? condition.maxColour + condition.targetColourIncrease : 255;
      color triangleColour = isTarget ? color(0, targetColourParam, 0) : grid_generate_triangle_colour(condition.maxColour);
      grid[row][column] = new Icon(row, column, 0, triangleColour, isTarget);
    }
  }
}

color grid_generate_triangle_colour(int maxColour) {
  color from = color(255, 255, 255);
  color to = color(144, 255, 144);
  return lerpColor(from, to, random(maxColour)/100);
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
            if(grid[row][column].isTarget && coords_in_triangle(mouseX, mouseY, (row*ROW_SIZE)+TRIANGLE_SIZE/2+width/4, (column*COLUMN_SIZE)-TRIANGLE_SIZE+height/4,
                       (row*ROW_SIZE)+TRIANGLE_SIZE+width/4, (column*COLUMN_SIZE)+height/4, 
                       (row*ROW_SIZE)+width/4, (column*COLUMN_SIZE)+height/4)){
                         grid_setup(condition);
                         condition.update_current_trial();
                         return true;
                       }
    }
  }
  return false;
}

///////////////////////////// SUM OF AREAS: CHECK IF POINT IS IN TRIANGLE //////////////////////////////////

float get_triangle_area(float ax, float ay, float bx, float by, float cx, float cy) {
    return abs((ax * (by - cy) + bx * (cy - ay) + cx * (ay - by)) / 2.0);
}

boolean coords_in_triangle(float test_x, float test_y, float x1, float y1, float x2, float y2, float x3, float y3) {
  float totalArea = get_triangle_area(x1, y1, x2, y2, x3, y3);

  float area1 = get_triangle_area(test_x, test_y, x2, y2, x3, y3);
  float area2 = get_triangle_area(x1, y1, test_x, test_y, x3, y3);
  float area3 = get_triangle_area(x1, y1, x2, y2, test_x, test_y);

  return abs(totalArea - (area1 + area2 + area3)) < 0.0001; // margin for floating point error
}
