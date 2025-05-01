%{
#include <stdio.h>
int positive_count = 0;
int negative_count = 0;
%}

%option noyywrap

%%

[1-9][0-9]*              { positive_count++; }
"-"[1-9][0-9]*           { negative_count++; }

[ \t\n]+                 { /* Ignore whitespace */ }
.                        { /* Ignore other characters */ }

%%

int main() {
    yylex();
    printf("Total positive integers: %d\n", positive_count);
    printf("Total negative integers: %d\n", negative_count);
    return 0;
}
