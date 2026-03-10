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

- Original coursework environment:
  - Windows
  - Keil uVision5
  - MDK-ARM 5.21a
  - MDK v4 Legacy Support
  - Device: `ARM9E-S (Little Endian)`
  - Toolchain: `ARM-ADS`

This repository keeps source files and project data only.

## Running

1. Create a new project in Keil uVision5.
2. Select `Legacy Device Database -> ARM -> ARM9E-S (Little Endian)`.
3. Add the target `.s` file to the project.
4. Build the project.
5. Start Debug mode with the simulator and inspect registers or memory as needed.

## Project

The final project is in `project-floating-point-inverse-matrix/`.

- `project.s`: main source
- `test-data/`: sample input and output data for `3x3`, `10x10`, and `20x20` cases
