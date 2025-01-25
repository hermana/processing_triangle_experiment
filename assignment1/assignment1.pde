 import java.util.ArrayList; 
 
 //////////////////////////////// CONSTANTS /////////////////////////////////////////////////////
 
 int GRID_SIZE=12;
 int ROW_SIZE=50;
 int COLUMN_SIZE=50;
 int TRIANGLE_SIZE=45;
 int MAX_INCORRECT_CLICKS_PER_TRIAL = 3;
 int MAX_TRIAL_TIME_MILLISECONDS = 20000;
 
 
 ExperimentPhase phase;
 Icon[][] grid;
 ArrayList<Condition> conditions = new ArrayList<Condition>();
 Condition currentCondition;
 int conditionIndex;
 
  //////////////////////////////// ICON CLASS /////////////////////////////////////////////////////
 
class Icon { 
  
   int row;
   int column;
   float rotation;
   color colour;
   boolean isTarget;
  
   Icon(int myRow, int myColumn, float myRotation, color myColour, boolean myIsTarget) {  
     row = myRow;
     column = myColumn;
     rotation = myRotation;
     colour = myColour;
     isTarget = myIsTarget;
  } 
  
  void drawIcon(){
   pushMatrix();
   fill(colour);
   translate(row*ROW_SIZE, column*COLUMN_SIZE);
   rotate(rotation);
   triangle(-TRIANGLE_SIZE/2, TRIANGLE_SIZE/2, TRIANGLE_SIZE/2, TRIANGLE_SIZE/2, 0, -TRIANGLE_SIZE/2);
   line(0, -TRIANGLE_SIZE/2, 0, TRIANGLE_SIZE/2);
   popMatrix();
  }

} 
////////////////////////////////// TRIAL CLASS ////////////////////////////////////////////////////

class Trial {

  int startTime;
  int endTime;
  int incorrectClicks;
  boolean successful;
  

   int get_trial_time(){
     return endTime - startTime;
   }
   
   int get_trial_elapsed_time(){
     return millis() - startTime;
   }
 
   Trial(){ 
     startTime = 0;
     endTime = 0;
     incorrectClicks=0;
     successful = true; //we'll assume unless marked otherwise
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
    ArrayList<Trial> trials;
    
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
      trials = new ArrayList<Trial>(numTrials);
      for(int i=0; i<numTrials; i++){ trials.add(new Trial()); }
    }
    
    void start_trial_timer(){
      trials.get(currentTrial-1).startTime = millis();
    }
    
    void end_trial_timer(){
      trials.get(currentTrial-1).endTime = millis();
    }
    
    int get_trial_elapsed_time(){
      return trials.get(currentTrial-1).get_trial_elapsed_time();
    }
    
    void add_trial_incorrect_click(){
      trials.get(currentTrial-1).incorrectClicks+=1;
    }
    
    int get_trial_incorrect_clicks(){
      return trials.get(currentTrial-1).incorrectClicks;
    }
    
    void set_trial_incorrect_clicks(int clicks){
      trials.get(currentTrial-1).incorrectClicks = clicks;
    }
    
    void update_current_trial(){
      trials.get(currentTrial-1).endTime = millis();
      currentTrial+=1;
    }
    
    void mark_current_trial_unsuccessful(){
      trials.get(currentTrial-1).successful= false;
    }
    
    int get_total_completion_time(){
      int total_time = 0;
      for(int i=0; i<numTrials;i++){
        total_time += trials.get(i).get_trial_time();
      }
      return total_time;
    }
    
    String get_manipulation_type_str(){
      return manipulationType == ManipulationType.COLOUR ? "COLOUR" : "ROTATION";
    }
    
    void print_results(){
      print("\n" + name + " " + get_manipulation_type_str() + " " + str(maxColour) + " " + str(targetColourIncrease) + " " + str(get_total_completion_time()));
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
  
  conditions.add(new Condition("Condition 3:", "In the next tasks, click on the triangle \n that is more rotated than the others.", ManipulationType.ROTATION, 0, 0, 10, 0, 90));
  conditions.add(new Condition("Condition 1:", "In the next tasks, click on the triangle \n that is more green than the others.", ManipulationType.COLOUR, 0, 0, 10, 255, 0));
  conditions.add(new Condition("Condition 2:", "In the next tasks, click on the triangle \n that is more green than the others.", ManipulationType.COLOUR, 0, 50, 10, 255, 0));
  //conditions.add(new Condition("Condition 3:", "In the next tasks, click on the triangle \n that is more rotated than the others.", ManipulationType.ROTATION, 0, 0, 10, 0, 90));

  conditionIndex = 0;
  currentCondition = conditions.get(conditionIndex);
  //set currentCondition  
  phase = ExperimentPhase.INSTRUCTIONS;
  grid_setup(currentCondition);
}

void draw() {
  
  
  background(200);
  switch(phase){
    case INSTRUCTIONS:
      text("Instructions", width/2, height/2);
      text("Click to continue.", width/2, (height/2)+50);
      break;
    case BEFORE_CONDITION: 
      text(currentCondition.name, width/2, height/2);
      text(currentCondition.instructions, width/2, (height/2)+50);
      text("Click to continue.", width/2, (height/2)+200);
      break;
    case BEFORE_TRIAL: 
      fill(0);
      text("Trial "+ str(currentCondition.currentTrial) +" of "+ str(currentCondition.numTrials), width/2-10, height/2);
      text("Click to continue.", width/2, (height/2)+150);
      break;
    case TRIAL: 
      background(200);
      fill(255, 204); // default colour
      stroke(0);
      pushMatrix();
      translate(width/4, height/4); 
      rect(-ROW_SIZE, -TRIANGLE_SIZE-COLUMN_SIZE, GRID_SIZE*ROW_SIZE + (ROW_SIZE*2), GRID_SIZE*COLUMN_SIZE + (COLUMN_SIZE*2));
      grid_draw();
      if(currentCondition.get_trial_elapsed_time() > MAX_TRIAL_TIME_MILLISECONDS){
        currentCondition.mark_current_trial_unsuccessful();
        currentCondition.update_current_trial();
        grid_setup(currentCondition);
        phase = ExperimentPhase.BEFORE_TRIAL;
      }
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
      currentCondition.start_trial_timer();
      break;
    case TRIAL: 
      if(grid_is_target_clicked()){
          currentCondition.end_trial_timer();
          if(currentCondition.currentTrial >= currentCondition.numTrials){
            currentCondition.print_results();
            phase = ExperimentPhase.FINISHED;
          }else{
             grid_setup(currentCondition);
             currentCondition.update_current_trial();
             phase = ExperimentPhase.BEFORE_TRIAL;
          }
      }else{
        currentCondition.add_trial_incorrect_click();
        if(currentCondition.get_trial_incorrect_clicks()>= MAX_INCORRECT_CLICKS_PER_TRIAL){
          //restart trial
          grid_setup(currentCondition);
          currentCondition.set_trial_incorrect_clicks(0);
          phase = ExperimentPhase.BEFORE_TRIAL;
        }
      }
      break;
    case FINISHED: 
      conditionIndex+=1;
      if(conditionIndex < conditions.size()){
         currentCondition = conditions.get(conditionIndex);
         phase = ExperimentPhase.INSTRUCTIONS;
         grid_setup(currentCondition);
      }
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
      color triangleColour = isTarget && condition.manipulationType == ManipulationType.COLOUR ? color(0, targetColourParam, 0) : grid_generate_triangle_colour(condition.maxColour);
      int rotation = isTarget ? condition.maxRotation + condition.targetRotationIncrease : int(random(condition.maxRotation));
      grid[row][column] = new Icon(row, column, radians(rotation), triangleColour, isTarget);
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
            if(grid[row][column].isTarget && coords_in_triangle(mouseX, mouseY, (row*ROW_SIZE)-TRIANGLE_SIZE/2+width/4, (column*COLUMN_SIZE)+(TRIANGLE_SIZE/2)+(height/4),
                       (row*ROW_SIZE)+(TRIANGLE_SIZE/2)+(width/4), (column*COLUMN_SIZE)+(TRIANGLE_SIZE/2)+(height/4), 
                       (row*ROW_SIZE)+width/4, (column*COLUMN_SIZE)-(TRIANGLE_SIZE/2)+(height/4))){
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
