%{
#include <stdio.h>

int sentence_count = 0;
%}

%option noyywrap

%%

[.!?]    { sentence_count++; }
[ \t\n]+ { /* Ignore spaces, tabs, and newlines */ }
.        { /* Ignore other characters */ }

%%

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    yyin = file;
    yylex();
    fclose(file);

    printf("Number of sentences: %d\n", sentence_count);
    return 0;
}
