%{
#include <stdio.h>
#include <string.h>
FILE *yyin;
int single_line_comments = 0;
int multi_line_comments = 0;
%}

%%

auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|inline|int|long|register|restrict|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while {
    printf("Reserved Word: %s\n", yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Identifier: %s\n", yytext);
}

[ \t\n]+ ;

"/*"([^*]|\*+[^*/])*\*+"/" {
    multi_line_comments++;
}

"//".* {
    single_line_comments++;
}

. ;

%%

int main() {
    yyin = fopen("input.c", "r");  // Open input.c for reading
    if (!yyin) {
        fprintf(stderr, "Could not open input.c\n");
        return 1;
    }
    yylex();
    fclose(yyin);  // Close the file after processing
    printf("Single-line comments: %d\n", single_line_comments);
    printf("Multi-line comments: %d\n", multi_line_comments);
    return 0;
}

int yywrap() {
    return 1;
}
