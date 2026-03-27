# RISC-V-Mastermind-Game

Overview
This project is a simple console-based version of the Mastermind game written in RISC-V assembly using RARS. The program generates a random 4-digit code using numbers 1–6 with no repeated digits, and the player has 10 attempts to guess it.

Features:
- Random code generation (digits 1–6, no repeats)
- Input validation to handle invalid or non-numeric input
- Black and white peg feedback system
- Attempt counter (10 attempts total)
- Win and lose conditions
- Play again option

How It Works:
When the program starts, the program generates a code (displayed for testing purposes). The user enters a 4-digit guess, and the program compares it to the secret code:
- Black means the correct number is in the correct position
- White means the correct number is in the wrong position

The game continues until the user guesses correctly or runs out of attempts.

What I Learned:
Through this project, I practiced:
- Working with registers and control flow in assembly
- Implementing logic without high-level language features
- Handling user input and validation
- Debugging and testing low-level programs

How to Run:
1. Open the file in RARS
2. Assemble and run the program
3. Follow the prompts in the console
   
Author:
Paul Mosincat
