# ARC 4 Decryption module
## Overview
This project involves designing an ARC4 decryption circuit and a related cracking circuit. ARC4 is a symmetric stream cipher that was once widely used for encrypting web traffic and wireless data. The project consists of the following tasks:


1. Initializing the ARC4 state
2. Implementing the Key-Scheduling Algorithm (KSA)
3. Implementing the Pseudo-Random Generation Algorithm (PRGA) and ARC4 decryption
4. Cracking ARC4 encryption using a brute-force approach
5. Parallelizing the cracking process to speed it up

The ARC4 decryption circuit takes an encrypted message and a secret key as input, and produces the decrypted plaintext message as output. The cracking circuit, on the other hand, attempts to find the secret key by trying all possible key combinations until a valid decryption is achieved.

## Hardware and Software
The project is designed to be implemented on the DE1-SoC board, which features a Cyclone V FPGA. The design is described in Verilog, and the Quartus Prime software is used for synthesis and programming the FPGA.

The project also includes testbenches for each module, which can be simulated using ModelSim.


<p align="center">
  <img src="https://github.com/AaranP/ARC-4-Decryption/assets/66931430/7769d813-ebf0-4689-8963-20f22c05d54a" alt="Screenshot 2024-05-05 152247"><br>
  <em>Figure 1: Overview of the ARC4 decryption circuit</em>
</p>


The ARC4 algorithm consists of three main phases: 
1. state initialization
2. key scheduling
3. pseudo-random generation.

The project implements all three phases in hardware, with each phase being a separate module.

The decryption circuit takes an encrypted message and a secret key as input, and performs the state initialization, key scheduling, and pseudo-random generation phases to produce the decrypted plaintext message.

The cracking circuit, on the other hand, implements a brute-force attack by trying all possible key combinations until a valid decryption is achieved. It does this by running the ARC4 decryption circuit repeatedly with different keys, and checking if the decrypted output meets certain criteria (e.g., consisting of only printable ASCII characters).

## Testing
The project includes comprehensive testbenches for each module, which are used for both RTL simulation and post-synthesis simulation. 

The testbenches cover various test cases, including edge cases and corner cases, to ensure the correctness of the implementation.

In addition to simulation, the project is also tested on the physical DE1-SoC board. The encrypted messages and the corresponding decrypted plaintext messages are known in advance, and the output of the decryption circuit is compared against the expected plaintext to verify its functionality.

For the cracking circuit, several encrypted messages with known keys are used for testing. The circuit is expected to find the correct key within a reasonable amount of time, and display the key on the seven-segment displays of the DE1-SoC board.

The parallelized cracking circuit is tested similarly, but with the expectation that it should crack the encryption approximately twice as fast as the non-parallelized version.

<!--
Figures
[Figure 4: Waveform showing the ARC4 decryption process]
[Figure 5: Simulation results for the cracking circuit, showing the correct key being found]
[Figure 6: Screenshot of the DE1-SoC board displaying the cracked key on the seven-segment displays]
