# Assembly x86-64 Tower of Hanoi

This project implements the Tower of Hanoi problem in x86-64 Assembly language. The Tower of Hanoi is a classic problem in computer science and mathematics, and this implementation showcases a recursive solution in Assembly.

## Table of Contents
- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Building and Running](#building-and-running)
- [Usage](#usage)
- [Code Structure](#code-structure)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Introduction

The Tower of Hanoi is a mathematical puzzle that involves three pegs and a number of disks of different sizes. The puzzle starts with the disks in a neat stack in ascending order of size on one peg, the smallest at the top. The objective is to move the entire stack to another peg, obeying the following simple rules:

1. Only one disk can be moved at a time.
2. Each move consists of taking the upper disk from one of the stacks and placing it on top of another stack or on an empty peg.
3. No disk may be placed on top of a smaller disk.

This project's implementation is written in x86-64 Assembly language and includes user input for the number of disks to use in the Tower of Hanoi problem.

## Getting Started

### Prerequisites

To run this project, you need to have an environment that supports x86-64 (Linux) Assembly language. You may use an emulator or run the code on a compatible system.
- Compatible online compiler suggestion: https://www.tutorialspoint.com/compile_assembly_online.php (works online under any OS)

### Building and Running

1. Clone the repository:

    ```bash
    git clone https://github.com/leticialevleitao/Assemblyx8664TowerOfHanoi.git
    cd Assemblyx8664TowerOfHanoi
    ```

2. Build and run the assembly code:

    ```bash
    nasm -f elf64 TowerOfHanoi.asm -o TowerOfHanoi.o
    ld -o TowerOfHanoi TowerOfHanoi.o
    ./TowerOfHanoi
    ```

## Usage

Upon running the executable, the program will prompt the user to input the number of disks to use in the Tower of Hanoi problem. The program will then solve the problem and display the movements.

## Code Structure

- `TowerOfHanoi.asm`: Main assembly file containing the Tower of Hanoi implementation.
- `TorreDeHAnoi.asm`: Main assembly file containing the Tower of Hanoi implementation (In Portuguese).
- `README.md`: Project documentation.
- `LICENSE`: License information for the project.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with any improvements or additional features.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- https://mentebinaria.gitbook.io/assembly/
- https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf

