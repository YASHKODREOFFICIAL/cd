%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_number = 1;

struct token {
    char type[20];
    char value[100];
    int line;
};

void print_token(struct token t) {
    printf("| %-15s | %-15s | %-5d |\n", t.type, t.value, t.line);
}
%}

%option noyywrap

%%

[0-9]+ {
    struct token t;
    strcpy(t.type, "INTEGER");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

[0-9]+\.[0-9]+ {
    struct token t;
    strcpy(t.type, "FLOAT");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

\'[^\']\' {
    struct token t;
    strcpy(t.type, "CHARACTER");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

[a-zA-Z] {
    struct token t;
    strcpy(t.type, "CHARACTER");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

[^a-zA-Z0-9\.\'\n\t\r ]+ {
    struct token t;
    strcpy(t.type, "INVALID TOKEN");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

\n {
    line_number++;
}

[ \t]+  { }

"//"[^'\n']* { }

. {
    struct token t;
    strcpy(t.type, "INVALID TOKEN");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

%%

int main() {
    char input[1024];

    printf("Enter input: ");
    fgets(input, sizeof(input), stdin);

    printf("| %-15s | %-15s | %-5s |\n", "Type", "Value", "Line");
    printf("|-----------------|-----------------|-------|\n");

    YY_BUFFER_STATE buffer = yy_scan_string(input);  // Create a buffer from input string
    yy_switch_to_buffer(buffer);  // Set the input buffer for Lex

    yylex();  // Perform lexical analysis

    yy_delete_buffer(buffer);  // Free the buffer after use
    return 0;
}
