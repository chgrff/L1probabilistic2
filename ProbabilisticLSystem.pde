// This is an implementation of an L-System that extends the class 
// "BaseLSystem", which makes it easy to make new types of LSystems (e.g., probabalistic)
// without repeating lots of code.
// It assumes all input vocabulary not given a rule are constants. 
// Though you could give an explicit rule for a constant using "F" --> "F"
// It contains a StringBuffer (currentIterationBuffer) that should be used
// to handle production rules when computing the currentIteration string as part of iterate
// in order avoid wasteful creation of strings and memory problems.
// The StringBuffer is used in the iterate method of the LSystem.
// @author: @mriveralee
import java.util.HashMap;

class LSystem extends BaseLSystem {
  
 // Production rules
  private HashMap<Character, String> rules;

  // Constructor for making an Lsystem object
  public LSystem(String axiom, HashMap<Character, String> rules, 
    float moveDistance, float rotateAngle, float scaleFactor) {            
    
    // Call Super Class constructor to initialize variables
    // You must always call this.
    super(axiom, moveDistance, rotateAngle, scaleFactor);
    
    // Set the Rules
    this.rules = rules;
    
    // Reset the state
    this.reset();
  }
  
  // runs 1 iteration, performing the rules for each character
  // on the current string. The result of the replacement is added to the currentIterationBuffer.
  public void iterate() {
    // Get a copy of the current iteration string
    String current = this.getIterationString();
    
    String replacement = "";
    
    float P = random(1);
    
    // Clear the current iteration string buffer
    this.clearCurrentStringBuffer();
    
    // Loop through each character in the current string
    for (int i = 0; i < current.length(); i++) {       
        char c = current.charAt(i);

    if (P < .33) {
        // Apply replacement rules based on the current character
        if (c == 'F') {
            replacement = "F[B]"; }  // Apply the rule for 'F'
        else if (c == 'B') {
            replacement = "F[-B]"; }  // Apply the rule for 'B'
        else {
            replacement = String.valueOf(c);  // No rule, keep the character unchanged
        }
    }  
    
    else if (P > .66) {
        if (c == 'F') {
            replacement = "FF[B]"; }  // Apply the rule for 'F'
        else if (c == 'B') {
            replacement = "FF[+B][-B]F"; }  // Apply the rule for 'B'
        else {
            replacement = String.valueOf(c);  // No rule, keep the character unchanged
        }
    }  
      else {
            replacement = String.valueOf(c);  // No rule, keep the character unchanged
    }  
        // Append the result of the replacement to the currentIterationBuffer
        currentIterationBuffer.append(replacement);
    }
    
    // Increment the iteration number
    iterationNum += 1;
}
  
  // This function uses the turtle to draw based on each character in the LSystem's 
  // iteration string. It also handles scaling the moveDistance (to keep the image in frame), if desired
  public void drawLSystem(Turtle t) {
    // Our turtle's move distance
    float dist = this.moveDistance;
    
    // Scale the movement, if necessary, to help keep the image in frame 
    // when it gets too big
    if (scaleFactor != 0) {
      // Get the current iteration number for scaling 
      int iterationNum = this.getIterationNum();
      dist = dist / (scaleFactor * (iterationNum + 1));
    }
    
    // Get the current iteration string
    String currentIteration = this.getIterationString(); 
    
    // [TODO]: Loop through each character in the iteration string,
    // and do turtle operations based on the character
    for (int i = 0; i < currentIteration.length(); i++) { 
      Character c = currentIteration.charAt(i); 
      // [TODO]: Implement different l-system vocabulary
      switch (c) {
        case 'F':
          t.forward(this.moveDistance);
          break; // The "break" exits out of the switch statement and prevents the next cases from running
          
          //need new case (right now B does nothin)
          case 'B':
          t.right(this.rotateAngle);
          t.forward(this.moveDistance);
          break; // The "break" exits out of the switch statement and prevents the next cases from running
         case '+':
          t.right(this.rotateAngle);
           break;
            case '-':
          t.left(this.rotateAngle);
           break;
              case '[':
          t.push();
           break;
              case ']':
          t.pop();
           break;
         default:
           // Throw an error if we don't have a draw operation implemented 
           throw new IllegalArgumentException("Missing a drawing operation case for character: " + c.toString());  
      }
    }
  }
}
