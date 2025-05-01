%{
#include <stdio.h>
#include <string.h>

int word_count = 0;
char target_word[] = "example";
%}

%option noyywrap

%%

[a-zA-Z]+ {
    if (strcmp(yytext, target_word) == 0) {
        word_count++;
    }
}

\n { }

%%

int main() {
    FILE *file = fopen("input.txt", "r");
    if (!file) {
        printf("File not found\n");
        return 1;
    }
    yyin = file;
    yylex();
    fclose(file);
    printf("Word '%s' frequency: %d\n", target_word, word_count);
    return 0;
}
