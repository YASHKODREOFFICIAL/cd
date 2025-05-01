%{
#include <stdio.h>
#include <string.h>
FILE *yyin;
%}

%%

auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|inline|int|long|register|restrict|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while {
    printf("| %-15s | %-10s |\n", "Reserved Word", yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("| %-15s | %-10s |\n", "Identifier", yytext);
}

[ \t\n]+ ;

. ;

%%

int main() {
    yyin = fopen("input.c", "r");  // Open input.c for reading
    if (!yyin) {
        fprintf(stderr, "Could not open input.c\n");
        return 1;
    }
    printf("| Type            | Value      |\n");
    printf("|-----------------|------------|\n");
    yylex();
    fclose(yyin);  // Close the file after processing
    return 0;
}

int yywrap() {
    return 1;
}
