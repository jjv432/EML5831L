# Lab 1 - Wall Follower

In this lab, we aim to steer an RC car to maintain a fixed distance from a wall using a PD (Proportional-Derivative) controller.

## Introduction to PD Controllers

PD controllers are a type of feedback loop mechanism widely used in control systems. They are particularly effective in systems where the control action is based on the error and its rate of change. The main components of a PD controller are:

1. **Proportional Control (P)**: This component produces an output that is proportional to the current error value. The proportional response can be adjusted by multiplying the error by a constant known as the Proportional Gain, `KP`. A higher `KP` increases the system's response to the error, leading to a faster correction but can also cause overshooting if too high.

2. **Derivative Control (D)**: This part of the controller produces an output that is proportional to the rate of change of the error. It helps to predict the future behavior of the error, thereby dampening the system's oscillations and improving stability. The derivative response is scaled by the Derivative Gain, `KD`.

### Function of PD Controllers in Wall Following

In the context of our wall-following RC car, the PD controller will help in:

- **Maintaining a Set Distance (Proportional Control)**: The P component ensures that the car maintains a constant distance from the wall by adjusting the steering based on the distance error (the difference between the desired and the actual distance from the wall).

- **Smoothing the Motion (Derivative Control)**: The D component anticipates future distance errors based on their rate of change, helping to smooth out the motion and avoid oscillations or sudden turns.

### Implementation

The implementation of the PD controller in this lab requires careful tuning of `KP` and `KD` gains. Appropriate values need to be chosen to achieve a balance between responsive steering and smooth navigation along the wall.

---

Follow the instructions in `main.m` for more details on how to implement and tune the PD controller for the RC car's wall-following behavior.
