%{
#include <stdio.h>
%}

%option noyywrap

%%

[0-9]{10}                   { printf("Valid Phone number: %s\n", yytext); }
[0-9]{3}-[0-9]{3}-[0-9]{4}  { printf("Valid Phone number: %s\n", yytext); }

[ \t\n]+                    { /* Ignore whitespace */ }
.                           { printf("Invalid token: %s\n", yytext); }

%%

int main() {
    printf("Enter input: ");
    yylex();
    return 0;
}
