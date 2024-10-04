        #include "robot.h" // low level functions
               
        unsigned long ticks=0;
             
        
        void setup() {
     
          // put your setup code here, to run once:
          timer_init();           
          encoder_init();  
          pwm_init(); 
          DDRB = 0XFF;
          
          Serial.begin(9600);
                  
        }
        
        
        void loop() {

         
          if((ticks % 100)==0) {


              //Serial.println(ticks);
              // Display Global Pose of the Robot
              Serial.print("X: "); Serial.print(robot_pos[0]); Serial.print("\t"); Serial.print("Y: "); Serial.print(robot_pos[1]);
              Serial.print("Th: "); Serial.println(robot_pos[2]*180/3.1415);
               
              // To calibrate encoder ticks per rev
              // Serial.print("enc0ticks: "); Serial.println(encoder_val[0]); 
              //Serial.print("enc1ticks: "); Serial.println(encoder_val[1]); 

          }         
                   
          
                  
        }
        
        /*****************************************************************************/
       
        
        /*************************  Control Function        ***************************/
        // Use this function to set your desired robot velocities
        void Control (void)
        {
         
          // wait 5 seconds to start moving
          if (ticks <= 500){
              des_robot_vel[0] = 0.0;
              des_robot_vel[1] = 0.0;
          }
          else if (ticks <= 900 )
              des_robot_vel[0] = 0.0;
              des_robot_vel[1] = 0.0;
          }

          else{
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
        
        
 
