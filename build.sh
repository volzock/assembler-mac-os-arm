#!/bin/bash
as -arch arm64 -o "$1.o" "$1.s"
ld -o $1 "$1.o" -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64
rm "$1.o"