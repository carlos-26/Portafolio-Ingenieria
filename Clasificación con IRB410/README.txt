# 🤖 Industrial Sorting Cell Simulation | ABB RobotStudio

## 📋 Project Overview
This project involves the design, simulation, and programming of an automated sorting cell using an **ABB IRB140** 6-axis industrial robot. The core objective was to develop a structured, robust robotic program capable of autonomously identifying, picking, and sorting objects based on millimeter-level height differences.

* **Software Used:** ABB RobotStudio, RAPID Programming Language.
* **Robot Model:** ABB IRB140.
* **Key Technologies:** Sensor-in-hand (Laser Distance Sensor), Vacuum Gripper, Structured Programming.

---

## ⚙️ Technical Challenge & Problem Statement
The robotic cell features a gravity feeder containing up to 8 boxes of two different product types. The challenge was to classify these boxes into two separate stacks based solely on their height.

**The complexity:**
1. The height difference between the two box types is minimal (**18mm vs. 19.5mm**).
2. The robot must use a "sensor-in-hand" approach (a Panasonic HG-C1200 laser distance sensor mounted on the end-effector) to measure the box dynamically before picking.
3. The program had to be robust enough to handle sensor measurement noise and work independently of the initial number of boxes in the feeder.

---

## 🛠️ Solution & Architecture
I developed a structured RAPID program to handle the logic, ensuring modularity and scalability.

### 1. Structured Programming (RAPID)
The logic was divided into clear, specific routines:
* **`Pick` Routine:** Moves the robot to the feeder, uses the laser sensor to scan the box, and applies a threshold logic to determine if the box is Type A (18mm) or Type B (19.5mm). If a box is detected, it activates the vacuum gripper.
* **`Place` Routine:** Calculates the dynamic drop-off position. Since the boxes must be stacked, the Z-coordinate (height) of the target position increments dynamically based on the numeric variables `CajasA` and `CajasB` (which act as counters for each sorted type).

### 2. Robustness Against Sensor Noise
To ensure reliability given the tight 1.5mm tolerance between box types, the logic doesn't rely on a single raw measurement. The program implements a tolerance band (thresholding) to classify the box, preventing false positives caused by environmental noise or sensor inaccuracies.

---

## 🏭 Real-World Implementation Analysis
As part of the engineering process, I analyzed the requirements for migrating this simulation to a physical industrial cell:

* **Commissioning Adjustments:** Real-world deployment requires strict Tool Center Point (TCP) calibration for both the vacuum gripper and the laser sensor. Additionally, the base frame (WorkObject) must be precisely aligned with the physical feeder and stacking pallets.
* **Hardware Optimization:** If the 1.5mm height difference proves too difficult to measure reliably with the laser sensor due to vibrations, alternative solutions include installing a lateral optical fork sensor on the feeder or using a vision system.
* **Industrial Safety:** A real-world cell requires physical guarding (fences), safety light curtains at the operator loading zone, and emergency stop circuits integrated into the robot controller.
* **Kinematic Optimization (SCARA Migration):** While this project uses a 6-axis robot, the sorting task only requires 4 degrees of freedom (X, Y, Z, and Yaw). By modifying the gravity feeder to present the boxes completely horizontally, a SCARA robot could perform this task much faster and more cost-effectively.
