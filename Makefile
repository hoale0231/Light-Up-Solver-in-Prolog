# Makefile
# CS3243 Homework 2I: Light Up

# Variables.

CC = gcc
ZIP = zip
MATRIC = U000000X
FLAGS = -g -Wall

# Make targets.

all:	input_helper output_helper

zip:	clean
	$(ZIP) submission-$(MATRIC).zip *

clean:
	-rm -f submission-$(MATRIC).zip input_helper output_helper 

input_helper:	input_helper.c
	$(CC) $(FLAGS) input_helper.c -o input_helper

output_helper:	output_helper.c
	$(CC) $(FLAGS) output_helper.c -o output_helper

