/**
Converts ascii 0s and 1s in .mem files to raw bytes for microSD card
parameters: filepath to convert
output: <filename>.dat with raw bytes from <filename>.mem ascii data

gcc -o <binaryname> MEMtoBytes.c
./<binaryname> <filepath to .mem file>
**/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    //check that there are exactly two arguments
    if (argc != 2) {
        printf("Formatting error: must be in form ./<executable> <file.mem>\n");
        exit(1);
    }

    //get input file from command line
    FILE *inputFile;
    char *fname = argv[1];
    
    //check for errors in loading file
    if ((inputFile = fopen(fname, "r")) == NULL){
        printf("File error: %s could not be found\n", fname);
        exit(1);
    }

    //check that fname has a .mem extension
    char *ext = ".mem";
    if (strstr(fname, ext) == NULL) {
        printf("File error: file must be of type .mem\n");
        printf("received file %s\n", fname);
        exit(1);
    }

    //create output file
    FILE *outputFile;
    char outName[50];
    snprintf(outName, sizeof outName, "%s.dat", strtok(fname, "."));
    outputFile = fopen(outName, "wb");

    int val;
    unsigned char byteBuffer = 0;
    unsigned char mask = 0;
    int counter = 0;
    do {
        //read each character in file
        val = fgetc(inputFile);
        //bit is 0
        if (val == 48){
            byteBuffer <<= 1;
            counter += 1;
        }
        //bit is 1
        if (val == 49){
            mask = 1;
            byteBuffer <<= 1;
            byteBuffer = byteBuffer | mask;
            counter += 1;
        }
        //write to output file when 8 bits have accumulated in buffer
        if (counter == 8){
            counter = 0;
            fwrite(&byteBuffer, 1, 1, outputFile);
        }
    } while (val != EOF);


    fclose(inputFile);
    fclose(outputFile);
    return 0;
}