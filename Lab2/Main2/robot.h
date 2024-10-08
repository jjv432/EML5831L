
// function prototypes
void pwm_init(void);
void pwm_set_duty(int channel, int duty);
void command_motor(int channel, int duty);
void fwdKinematics(void);
void timer_init(void);
void GetCurrentStatus(void);
void Motor_Control(void);

// Encoder Functions
void encoder1CHB(void);
void encoder1CHA(void);
void encoder2CHB(void);
void encoder2CHA(void);
void encoder_read(void);
void encoder_init(void);


#define pi 3.141516
#define Gear_Ratio 50
#define del_T 0.01        // [s]
#define wheelRad 0.0635   // [m]
#define robotWidth 0.131  // [m] This is B; already divided by 2!

// controller constants
#define Kp 50.0
#define Kd 10.0
#define Vcc 7.2
float des_Vol[2] = { 0., 0. };
int duty_cycle[2];


// pins for encoder 1
const byte interruptPIN2 = 2;
const byte interruptPIN3 = 3;

// pins for encoder 2
const byte interruptPIN18 = 18;
const byte interruptPIN19 = 19;


long int encoder_val[2] = { 0, 0 };

float joint_pos[2] = { 0.0, 0.0 };       // acual wheel position in rad, 0: left, 1: right
float joint_vel[2] = { 0.0, 0.0 };       // actual wheel velocity in rad/s, 0:left, 1: right
float robot_vel[2] = { 0.0, 0.0 };       // robot forward[m/s] and angular velocity[rad/s]
float robot_pos[3] = { 0.0, 0.0, 0.0 };  // robot gloabal pose X[m],Y[m], Theta[rad]
byte state1 = 0;                         // for encoders
byte state2 = 0;

float des_joint_pos[2] = { 0.0, 0.0 };       // desired wheel positions
float prev_des_joint_pos[2] = { 0.0, 0.0 };  // previous desired wheel positions
float des_joint_vel[2] = { 0.0, 0.0 };       // desired wheel velocities
float des_robot_vel[2] = { 0.0, 0.0 };       // desired robot velocities, 0: fwd vel,1: angular vel
float dv = 0.0575;
float dw = -0.0107;
void pwm_init(void) {

  pinMode(45, OUTPUT);
  pinMode(46, OUTPUT);

  TCCR5A = _BV(COM5A1) | _BV(COM5B1) | _BV(WGM52) | _BV(WGM50);
  TCCR5B = _BV(CS51) | _BV(CS50);  //set prescaler to 128
  OCR5A = 0;
  OCR5B = 0;
}

void pwm_set_duty(int channel, int duty) {

  if (channel == 0)
    OCR5A = duty;
  else if (channel == 1)
    OCR5B = duty;
}

void command_motor(int channel, int duty) {

  if (channel == 0) {
    if (duty > 0) PORTB = (PORTB & 0b11111101) | 1;
    else PORTB = (PORTB & 0b11111110) | 2;
  } else {
    if (duty > 0) PORTB = (PORTB & 0b11110111) | 4;
    else PORTB = (PORTB & 0b11111011) | 8;
  }


  pwm_set_duty(channel, abs(duty));
}


void timer_init(void) {
  // initialize timer1
  noInterrupts();  // disable all interrupts
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1 = 0;
  //625 for 100Hz, 125 for 500Hz
  OCR1A = 625;              // compare match register 16MHz/256/2Hz
  TCCR1B |= (1 << WGM12);   // CTC mode
  TCCR1B |= (1 << CS12);    // 256 prescaler
  TIMSK1 |= (1 << OCIE1A);  // enable timer compare interrupt
  interrupts();             // enable all interrupts
}


void encoder_init(void) {

  // encoder 1
  pinMode(interruptPIN2, INPUT_PULLUP);
  pinMode(interruptPIN3, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPIN2), encoder1CHA, CHANGE);
  attachInterrupt(digitalPinToInterrupt(interruptPIN3), encoder1CHB, CHANGE);

  // encoder 2
  pinMode(interruptPIN18, INPUT_PULLUP);
  pinMode(interruptPIN19, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPIN18), encoder2CHA, CHANGE);
  attachInterrupt(digitalPinToInterrupt(interruptPIN19), encoder2CHB, CHANGE);
}

void encoder1CHA(void) {

  //digitalReadFast(interruptPIN2);
  if ((state1 == 0) && (digitalRead(interruptPIN2) == 1))

  //if ((state1 == 0) && (digitalReadFast(interruptPIN2) ==1))

  {
    state1 = 2;
    encoder_val[0] -= 1;
  } else if ((state1 == 2) && (digitalRead(interruptPIN2) == 0))
  //else if ((state1==2) && (digitalReadFast(interruptPIN2) ==0))


  {
    state1 = 0;
    encoder_val[0] += 1;
  }

  else if ((state1 == 1) && (digitalRead(interruptPIN2) == 1))
  //else if ((state1==1) && (digitalReadFast(interruptPIN2) ==1))
  {
    state1 = 3;
    encoder_val[0] += 1;
  } else if ((state1 == 3) && (digitalRead(interruptPIN2) == 0))
  //else if ((state1==3) && (digitalReadFast(interruptPIN2) ==0))


  {
    state1 = 1;
    encoder_val[0] -= 1;
  }
}

void encoder1CHB(void) {


  if ((state1 == 0) && (digitalRead(interruptPIN3) == 1))
  //if ((state1 == 0) && (digitalReadFast(interruptPIN3) ==1))

  {
    state1 = 1;
    encoder_val[0] += 1;
  } else if ((state1 == 3) && (digitalRead(interruptPIN3) == 0))
  //else if ((state1==3) && (digitalReadFast(interruptPIN3) ==0))

  {
    state1 = 2;
    encoder_val[0] += 1;
  }

  else if ((state1 == 2) && (digitalRead(interruptPIN3) == 1))
  // else if ((state1==2) && (digitalReadFast(interruptPIN3) ==1))


  {
    state1 = 3;
    encoder_val[0] -= 1;
  } else if ((state1 == 1) && (digitalRead(interruptPIN3) == 0))
  //else if ((state1==1) && (digitalReadFast(interruptPIN3) ==0))

  {
    state1 = 0;
    encoder_val[0] -= 1;
  }
}

// Encoder 2 functions

void encoder2CHA(void) {

  if ((state2 == 0) && (digitalRead(interruptPIN18) == 1))
  //if ((state2 == 0) && (digitalReadFast(interruptPIN18) ==1))


  {
    state2 = 2;
    encoder_val[1] -= 1;
  } else if ((state2 == 2) && (digitalRead(interruptPIN18) == 0))
  //  else if ((state2==2) && (digitalReadFast(interruptPIN18) ==0))

  {
    state2 = 0;
    encoder_val[1] += 1;
  }

  else if ((state2 == 1) && (digitalRead(interruptPIN18) == 1))
  //   else if ((state2==1) && (digitalReadFast(interruptPIN18) ==1))

  {
    state2 = 3;
    encoder_val[1] += 1;
  } else if ((state2 == 3) && (digitalRead(interruptPIN18) == 0))
  //else if ((state2==3) && (digitalReadFast(interruptPIN18) ==0))

  {
    state2 = 1;
    encoder_val[1] -= 1;
  }
}

void encoder2CHB(void) {

  if ((state2 == 0) && (digitalRead(interruptPIN19) == 1))
  //if ((state2 == 0) && (digitalReadFast(interruptPIN19) ==1))

  {
    state2 = 1;
    encoder_val[1] += 1;
  } else if ((state2 == 3) && (digitalRead(interruptPIN19) == 0))
  //else if ((state2 == 3) && (digitalReadFast(interruptPIN19) ==0))

  {
    state2 = 2;
    encoder_val[1] += 1;
  }

  else if ((state2 == 2) && (digitalRead(interruptPIN19) == 1))
  //else if ((state2==2) && (digitalReadFast(interruptPIN19) ==1))
  {
    state2 = 3;
    encoder_val[1] -= 1;
  }

  else if ((state2 == 1) && (digitalRead(interruptPIN19) == 0))
  //else if ((state2==1) && (digitalReadFast(interruptPIN19) ==0))

  {
    state2 = 0;
    encoder_val[1] -= 1;
  }
}


// the ticks per rev might need calibration
// once the code is finished have the loop print the encoder values.
// rotate wheel by hand and see ticks per rev

void GetCurrentStatus(void) {
  static float prev_pos[2] = { 0.0, 0.0 };

  //joint_pos[0] = encoder_val[0]*2*pi/(Gear_Ratio*400);
  joint_pos[0] = encoder_val[0] * 2 * pi / (17984.0);

  joint_vel[0] = (joint_pos[0] - prev_pos[0]) / del_T;

  prev_pos[0] = joint_pos[0];

  //joint_pos[1] = -1.0*encoder_val[1]*2*pi/(Gear_Ratio*400);
  joint_pos[1] = -1.0 * encoder_val[1] * 2 * pi / (17984.0);

  joint_vel[1] = (joint_pos[1] - prev_pos[1]) / del_T;

  prev_pos[1] = joint_pos[1];

  fwdKinematics();  // compute robot velocities and update robot global pose
}

void fwdKinematics(void) {

  // compute the actual robot fwd and angular velocities using the measured joint velocities

    // //theta_dot_r = (1/R)*(vx + Bw)
  // joint_vel[1] = (1. / wheelRad) * (robot_vel[0] + robotWidth * robot_vel[1]);


  // //thetat_dot_l = (1/R)*(vx - Bw)
  // joint_vel[0] = (1. / wheelRad) * (robot_vel[0] - robotWidth * robot_vel[1]);


  // Compute estimate of robot global position and orientation

  //vc = (R/2)* theta_dot_r + (wheelRad/2)* theta_dot_l
  robot_vel[0] = (wheelRad / 2.) * joint_vel[1] + (wheelRad / 2.) * joint_vel[0];

  //wc = (-R/b) * theta_dot_r + (R/b) * theta_dot_l
  robot_vel[1] = (wheelRad / robotWidth) * joint_vel[1] + (-wheelRad / robotWidth) * joint_vel[0];

  //Xdot = v*cos(phi)
  float x_dot = robot_vel[0] * cos(robot_pos[2]);

  //ydot = v*sin(phi)
  float y_dot = robot_vel[0] * sin(robot_pos[2]);

  //phi_d = w
  float phi_dot = robot_vel[1];

  //x = xdot*del_T + x_prev
  robot_pos[0] = x_dot * del_T + robot_pos[0];

  //y = ydot*del_T + y_prev
  robot_pos[1] = y_dot * del_T + robot_pos[1];
  

  //phi = w
  robot_pos[2] = phi_dot * del_T + robot_pos[2];


  // constrain heading angle to [-pi pi]

  robot_pos[2] = atan2(sin(robot_pos[2]), cos(robot_pos[2]));

  

}

void invKinematics(void) {
  // compute desired joint velocities based on desired robot velocities

  //theta_dot_l = (1/R) * (vx - Bw)

  des_joint_vel[0] = (1/wheelRad) * (des_robot_vel[0] - robotWidth * des_robot_vel[1]);
  

  //theta_dot_r = (1/R) * (vx + Bw)

  des_joint_vel[1] = (1/wheelRad) * (des_robot_vel[0] + robotWidth * des_robot_vel[1]);

}

void Motor_Control(void) {

  int i;

  // map desired robot velocities to desired wheel velocities
  invKinematics();

  // PD control Law
  for (i = 0; i < 2; i++) {
    des_joint_pos[i] = prev_des_joint_pos[i] + des_joint_vel[i] * del_T;
    prev_des_joint_pos[i] = des_joint_pos[i];
    des_Vol[i] = Kp * (des_joint_pos[i] - joint_pos[i]) + Kd * (des_joint_vel[i] - joint_vel[i]);

    // duty_cycle[i] = (int)(des_Vol[i])/Vcc*255;
    duty_cycle[i] = (des_Vol[i]) / Vcc * 255;

    if (duty_cycle[i] > 255)
      duty_cycle[i] = 255;
    else if (duty_cycle[i] < -255)
      duty_cycle[i] = -255;
  }

  command_motor(0, duty_cycle[0]);
  command_motor(1, duty_cycle[1]);
}
