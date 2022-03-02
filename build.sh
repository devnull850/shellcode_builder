#!/bin/bash

as -o test.o test.s
LENGTH=$(objdump -d test.o | tail -n 1 | sed 's/\x20//g' | tr ':' '\n' | \
	head -n 1) 

INST=$(objdump -d test.o | tail -n 1 | tr '\t' '\n' | \
	grep -P '([0-9a-f]{2}(\x20|\x0a))+' | wc -w)

COUNT=$((0x${LENGTH}+INST))

dd if=test.o of=bytes bs=1 count=$COUNT skip=64
rm test.o

CODE=$(xxd bytes | sed 's/^[0-9]\{8\}://g' | sed 's/.\{16\}$//g' | \
	tr '\n' ' ' | sed 's/\x20//g' | sed 's/\(..\)/\\x&/g')

echo $CODE > shellcode
rm bytes
