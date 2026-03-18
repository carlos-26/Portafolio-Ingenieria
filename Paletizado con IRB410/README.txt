# 📦 Parametric Palletizing Cell | ABB RobotStudio

## 📋 Project Overview
This project involves the design and programming of an automated robotic palletizing cell using an **ABB Industrial Robot**. The core objective was to develop a fully parametric RAPID program capable of stacking boxes on a pallet using interlocking layer patterns to ensure load stability, without hardcoding individual drop-off positions.

* **Software Used:** ABB RobotStudio, RAPID Programming Language.
* **Key Technologies:** Parametric Programming, Vacuum Gripper (TCP configuration), Euler Angles Kinematics, Dynamic Offsets.

---

## ⚙️ Technical Challenge & Problem Statement
In industrial palletizing, hardcoding every single position for hundreds of boxes is inefficient and impossible to scale. The challenge was to create a scalable algorithm to handle a 9-box palletizing cycle (3 boxes per layer, 3 layers).

**Key constraints:**
1. **Dynamic Picking:** The picking height on the gravity feeder changes as boxes are removed.
2. **Interlocking Patterns:** To guarantee the physical stability of the pallet, alternating layers (odd vs. even) must have different orientations (90-degree shift) and spatial layouts.
3. **Payload Kinematics:** The robot's Tool Center Point (TCP) changes dimensionally depending on whether it is carrying a box or empty.

---

## 🛠️ Solution & Architecture
I developed a highly structured and mathematical RAPID program to dynamically calculate all positions in real-time.

### 1. Parametric Algorithm (`Armar_pila` Routine)
Instead of teaching 9 different `robtargets`, the program uses a single base reference (`PPLACE1`) and calculates the rest using the `Offs()` function.
* **Layer Tracking:** A `WHILE` loop combined with a Modulo operator (`CajasEnPalet MOD 3 = 0`) automatically tracks when a layer is full and increments the Z-axis (height) for the next stack.
* **Euler Angle Rotations:** The routine dynamically applies rotations using `OrientZYX()`. For odd layers, the coordinate system is shifted by `dx_PPLACE1` (130mm) and rotated 90 degrees, automatically generating the interlocking pattern.

### 2. WorkObject Separation
The code utilizes distinct WorkObjects (`WObj`) to separate the physics of the cell:
* `RMESA`: The coordinate system for the picking table.
* `RPALET`: The coordinate system for the palletizing zone.
This makes the code modular; if the physical pallet is moved on the factory floor, only the `RPALET` frame needs to be recalibrated, leaving the entire logic intact.

### 3. Dynamic TCP Definition
To ensure accurate trajectory planning and avoid collisions, I defined two distinct `tooldata` parameters:
* `Sopapa`: The TCP of the bare vacuum gripper.
* `Sopapa_caja`: The TCP shifted by 15mm in the Z-axis to account for the physical dimensions of the box being carried.

---

## 🏭 Industrial Value & Scalability
This project demonstrates production-ready logic. Because the code is variable-driven (`cant_cajas:=9`, `h_caja:=15`), modifying the cell to handle 50 boxes or a different box size takes seconds—requiring only changes to the initial constants rather than reprogramming the entire trajectory tree.

---

## 🚀 Simulation Video
[Watch the RobotStudio Simulation](https://photos.app.goo.gl/8Nq6jSaerAmwjkEn7)