/*
 * input_helper.c
 * CS3243 Homework 2I: Light Up
 *
 * Sample C code framework for an input helper for Light Up.
 *
 * See ATTENTION STUDENT for places that you may need to change.
 */

#include <stdio.h>
#include <stdlib.h>

#define FALSE 0
#define TRUE 1

/*
 * Global variables.
 */

int g_numrows;
int g_numcols;
char** g_grid;

/*
 * Reads input file subject to specifications on: 
 * http://www.comp.nus.edu.sg/~kanmy/courses/3243_2007/hw-lightup.html
 */

void readInputFile(char* inputfile) {
	FILE* fp;
	char* buf;
	int r;
	int c;

	/* Open input file. */
	fp = fopen(inputfile, "r");
	if (fp == NULL) {
		fprintf(stderr, "Error: Unable to open input file %s\n", inputfile);
		exit(1);
	}

	/* Read input file and construct grid. */
	fscanf(fp, "%d %d", &g_numrows, &g_numcols);
	g_grid = (char**)malloc(sizeof(char*) * g_numrows);
	for (r = 0; r < g_numrows; r++)
		g_grid[r] = (char*)malloc(sizeof(char) * g_numcols);
	buf = (char*)malloc((g_numcols + 1) * sizeof(char));
	for (r = 0; r < g_numrows; r++) {
		fscanf(fp, "%s", buf);
		for (c = 0; c < g_numcols; c++)
			g_grid[r][c] = buf[c];
	}

	/* Close file. */
	fclose(fp);
}

/*
 * ATTENTION STUDENT: Here you will output a query file. This query file first
 * loads the lightup.pl KB file. Next, it issues a query that will ask Prolog to
 * solve the puzzle, which is connected by the "and" connective ',' to
 * statements that outputs the solution for the output helper program. If you
 * change the semantics of the parameters of the solve rule, you will need to
 * modify your query. Depending on the structure of your pipeline, you might
 * need to have this input helper program output another puzzle-specific KB file
 * and have the query file load both KB files. It is also possible that nothing
 * in this input helper program needs to be changed, if you modify only the
 * lightup.pl KB file.
 */

void writeQueryFile(char* queryfile) {
	FILE* fp;
	int count;
	int r;
	int c;
	int first;

	fp = fopen("data.pl", "w");
	if (fp == NULL) {
		fprintf(stderr, "Error: Unable to open output data file data.pl\n");
		exit(1);
	}

	// Declare white cell
	for (r = 0; r < g_numrows; r++) {
		for (c = 0; c < g_numcols; c++) {
			if (g_grid[r][c] == '.') {
				fprintf(fp, "whiteCell([%d, %d]).\n", r, c);
			}
		}
	}
	fprintf(fp, "numberCell([-1, -1, 0]).\n");	
	// Declare number cell
	for (r = 0; r < g_numrows; r++) {
		for (c = 0; c < g_numcols; c++) {
			if (g_grid[r][c] >= '0' && g_grid[r][c] <= '4') {
				count = g_grid[r][c] - '0';
				fprintf(fp, "numberCell([%d, %d, %d]).\n", r, c, count);
			}
		}
	}
	fclose(fp);

	/* Open output query file. */
	fp = fopen(queryfile, "w");
	if (fp == NULL) {
		fprintf(stderr, "Error: Unable to open output query file %s\n", queryfile);
		exit(1);
	}

	/* Load rules from KB file. */
	fprintf(fp, "consult('data.pl').\n");

	fprintf(fp, "consult('lightup.pl').\n");

	/* Query to find the solution. The sample query is of the form,
         * lightup(WhiteCells, NumberConstraints, Bulbs). */
	fprintf(fp, "lightup([");
	first = TRUE;
	for (r = 0; r < g_numrows; r++) {
		for (c = 0; c < g_numcols; c++) {
			if (g_grid[r][c] == '.') {
				if (first)
					first = FALSE;
				else
					fprintf(fp, ", ");
				fprintf(fp, "[%d, %d]", r, c);
			}
		}
	}
	fprintf(fp, "]),\n");
	
	/* Continue with output statements suitable for loading in the output
	 * helper program. The sample output gives, in each line, the
         * coordinates of a bulb. */

	/* We are done now. */
	fprintf(fp, "\thalt.\n");

	/* Close file. */
	fclose(fp);
}

/*
 * Usage message, run if invoked incorrectly.
 */

void usage(char* progname) {
	fprintf (stderr, "Usage: %s input_file output_query_file\n", progname);
	exit(1);
}

/*
 * Main function.
 */

int main(int argc, char** argv) {
	/* Check number of parameters. */
	if (argc != 3)
		usage(argv[0]);

	/* Read the grid from the input file. */
	readInputFile(argv[1]);

	/* Write the query file. */
	writeQueryFile(argv[2]);

	return 0;
}

