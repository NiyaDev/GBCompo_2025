#!/bin/bash

clear


rgbasm  -o target/GBJam.o  src/main.asm
rgblink -o target/GBJam.gb target/GBJam.o
rgbfix     target/GBJam.gb -c -i AWQE -j -k 4F -l 0x03 -m 0x1B -r 0x02 -t "GBJAM25" -v -p 0x00

