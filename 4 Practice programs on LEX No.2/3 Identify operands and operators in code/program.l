%{
#include <stdio.h>

void print_header() {
    printf("| %-10s | %-10s |\n", "Type", "Value");
    printf("|------------|------------|\n");
}
int printed = 0;
%}

%option noyywrap

%%

[a-zA-Z_][a-zA-Z0-9_]* {
    if (!printed) {
        print_header();
        printed = 1;
    }
    printf("| %-10s | %-10s |\n", "Operand", yytext);
}

"="|"+"|"-"|"*"|"/" {
    if (!printed) {
        print_header();
        printed = 1;
    }
    printf("| %-10s | %-10s |\n", "Operator", yytext);
}

[ \t\n]+ { }

. { }

%%

int main() {
    printf("Enter input: ");
    yylex();
    return 0;
}
