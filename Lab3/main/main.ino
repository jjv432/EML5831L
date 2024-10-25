        #include "robot.h" // low level functions
        #include "purepursuit.h" // waypoint following functions    
               
        unsigned long ticks=0;
             
        // Coordinates of the desired waypoints in the Global Frame. Units in [m]
        float wY[3] = {.5,1, 1.5}; // X coordinates of desired waypoints
        float wX[3] = {.5,.5,1}; // Y coordinates of desired waypoints
        int wayPointIndex = 0; //increase once pssing a wp 
        int nWayPoints = 3; // number of way points
        float goalTh = 0.05; // if robot is closer than this distance, it will assume it has arrived to the
                             // waypoint
                             
        int flagRad;
        float localPhi;
                
        void setup() {
     
          // put your setup code here, to run once:
          timer_init();           
          encoder_init();  
          pwm_init(); 
          DDRB = 0XFF;
          
          Serial.begin(9600);
                  
        }
        
        
        void loop() {

          // For debug, print global robot pose
                    
          if((ticks % 100)==0) {
           
              // To calibrate encoder ticks per rev
              //Serial.print("enc0ticks: "); Serial.println(encoder_val[0]); 
              //Serial.print("enc1ticks: "); Serial.println(encoder_val[1]); 

          }         
                   

          // run this low priority, non real time function
          
          if( (ticks % 10)== 0 ) {
            runPurePursuit();         
          }
          
          
                  
        }
        
        /*****************************************************************************/
       
        
        /*************************  Control Function        ***************************/
        
        void Control (void)
        {
          
          // wait 5 seconds to start moving
          if ( (ticks <= 500) || (wayPointIndex > nWayPoints-1) ){
              des_robot_vel[0] = 0.0;
              des_robot_vel[1] = 0.0;
          }

          GetCurrentStatus(); 
          Motor_Control();
          ticks++;      
          
     }
       
       
        /*****************************************************************************/
        ISR(TIMER1_COMPA_vect)      // timer compare interrupt service routine
        {
          Control();
           
        }
        /********************************************************************/
        
        
        // Implement your main purepursuit function here.
        // inside this function you should command the robot
        // with the desired fwd and angular velocities (des_robot_vel[0] and des_robot_vel[1])

        // Note: Make sure to implement the following functions inside purepursuit.h (look in there for more details):
        
        //findDistance2Goal -> returns the distance from the robot current location to a desired goal location
        //                     Takes in robot pos and current waypoint pos
        
        //findTurnRadius -> finds the turn radius to execute using the purepursuit algorithm. It also provides 
        // a flag indicating if the waypoint is in front of the vehicle, or behind. You can use this info to decide if you
        //need to do a point turn or not
        
        void runPurePursuit(void){
              float d2Goal;
              float turnRadius; // in m
              flagRad;
              float local_x, local_y;
              des_robot_vel[0] = .25;

              
              turnRadius = findTurnRadius(robot_pos[0],robot_pos[1],robot_pos[2], wX[wayPointIndex], wY[wayPointIndex], &flagRad, &localPhi);

              // write your code here
              
              if (!flagRad){
                //point turn
                des_robot_vel[0] = 0;
                des_robot_vel[1] = .2;
              } 
              else if (flagRad){
                //follow the radius with a constant forward velocity
                des_robot_vel[1] = des_robot_vel[0] / turnRadius;

              }
              // find the Euclidean distance to the WP
              float distance = findDistance2Goal(robot_pos[0],robot_pos[1], wX[wayPointIndex], wY[wayPointIndex]);
              // Serial.print(distance);
              // Serial.print("\t");
              // Serial.println(goalTh);

              // if you're close enough to the current waypoint, and there are still waypoints left, move to the next waypoint
              if ((distance < goalTh) && (wayPointIndex < nWayPoints)) {
                  wayPointIndex ++;
                  
              }
              // if you've run out of waypoints, stop
              else if (wayPointIndex == nWayPoints){
                
                des_robot_vel[1] = 0;
                des_robot_vel[0] = 0;
              }


          
          
        }
