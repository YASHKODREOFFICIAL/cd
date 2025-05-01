%{
#include <stdio.h>

int balance = 0;

%}

%option noyywrap

%%

"(" { balance++; }
")" { balance--; }

.    { }

%%

int main() {
    yylex();
    if (balance == 0) {
        printf("Parentheses are balanced\n");
    } else {
        printf("Parentheses are not balanced\n");
    }
    return 0;
}
