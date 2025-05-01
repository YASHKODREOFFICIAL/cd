%{
#include <stdio.h>

int digits = 0;
int letters = 0;
int special_chars = 0;
%}

%option noyywrap

%%

[0-9]        { digits++; }
[a-zA-Z]     { letters++; }
[\n\t\r ]    { /* ignore whitespace */ }
.            { special_chars++; }

%%

int main() {
    printf("Enter input: ");
    yylex();

    printf("\nTotal counts:\n");
    printf("Digits: %d\n", digits);
    printf("Letters: %d\n", letters);
    printf("Special characters: %d\n", special_chars);

    return 0;
}
