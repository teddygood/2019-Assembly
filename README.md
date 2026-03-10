# 2019 Assembly

Assembly Language Programming coursework archive from 2019.

## Contents

- `assignment-01/`
  - memory transfer and addressing
- `assignment-02/`
  - control flow, arrays, and string problems
- `assignment-03/`
  - arithmetic and factorial
- `assignment-04/`
  - block data transfer, stack, and subroutines
- `assignment-05/`
  - floating-point addition
- `assignment-06/`
  - string copy
- `project-floating-point-inverse-matrix/`
  - floating-point inverse matrix project

## Environment

- Windows
- Keil uVision5
- MDK-ARM 5.21a
- MDK v4 Legacy Support
- Device: `ARM9E-S (Little Endian)`
- Toolchain: `ARM-ADS`

All assignment and project folders include the original Keil project files. The projects are configured to run with the simulator, and the required `memory.ini` file is already registered in each `.uvproj`.

## Running

1. Open the target `.uvproj` file in Keil uVision5.
2. Confirm the target device is `ARM9E-S (Little Endian)`.
3. Build the project.
4. Start Debug mode with the simulator.
5. Check registers, memory, and output values in the debugger.

If memory access fails in Debug mode, open `Options for Target -> Debug` and confirm that the folder-local `memory.ini` file is selected as the initialization file.

## Project

The final project is in `project-floating-point-inverse-matrix/`.

- `project.s`: main source
- `project.uvproj`: Keil project file
- `memory.ini`: simulator memory map
- `test-data/`: sample input and output data for `3x3`, `10x10`, and `20x20` cases
