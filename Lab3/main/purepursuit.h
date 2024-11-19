/* Purepursuit Implementation
Mobile Robotics Fall2023
Instructor: Camilo Ordonez 
Student Template
*/

// inputs 
// rX,rY,rP: robot pose
// wX, wY: waypoint coordinates in global frame
// flag: pointer to indicate the type of desired turn

// output: turnradius to be followed to reach the desired waypoint
#define PI 3.141516

float findTurnRadius(float rX,float rY,float rP,float wX,float wY, int *flag);

// function to compute the distance from the robot to the waypoint.
float findDistance2Goal(float rX, float rY,float wX,float wY);

/*//////////////////////////////////////////////////////////////////////////////////////////////
 * /////////////////////// Write Helper Functions Below!! Skeleton already given////////////////
 * /////////////////////////////////////////////////////////////////////////////////////////////
 */
float findTurnRadius(float rX,float rY,float rP,float wX,float wY,int *flag, float *local_phi){
  //recomended variables
	//float gx_global_tx, gy_global_tx, gx_local,gy_local,lsquared,,th;
	
	// Compute the goal waypoint in local robot coordinates (gy_local,gx_local)
  float local_x = cos(rP) * (wX - rX) + sin(rP) * (wY - rY);
  float local_y = cos(rP) * (wY - rY) - sin(rP) * (wX - rX);

  //Determine the angle between the robot's current heading and the waypoint (use atan2()) 
  *local_phi = atan2(local_y, local_x);

  //Check if the goal is behind the robot
    //if yes, set a flag (*flag) to perform a point turn in the appropriate direction
    //otherwise, determine turn required turn radius (Set flag to appropriate value here as well 

  // if the waypoint is behind you, set a flag variable to 0
  if ((*local_phi > PI/2) || (*local_phi < (-PI/2)))
    *flag = 0;
  else
    *flag = 1;

  float l_squared = pow(local_x,2) + pow(local_y,2);

  float turnRadius = l_squared/(2.*local_y);11111111111111111

  return turnRadius;
}


float findDistance2Goal(float rX, float rY,float wX,float wY){
  
  float d2Goal;
  //distance formula (used to check if robot is within threshhold of waypoint)

  // euclidean distance to wp
  d2Goal = sqrt(pow((wX - rX),2) + pow((wY- rY), 2));

  return d2Goal;
  
}
