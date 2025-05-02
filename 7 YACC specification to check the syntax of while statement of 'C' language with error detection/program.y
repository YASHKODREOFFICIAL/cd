%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
extern FILE *yyin;  // Declare yyin globally
%}

%token WHILE LPAREN RPAREN LBRACE RBRACE SEMI ID NUMBER EXIT

%%

input:
    stmts EXIT { printf("Valid while loop syntax\n"); return 0; }
;

stmts:
    stmt
  | stmts stmt
;

stmt:
    while_stmt
;

while_stmt:
    WHILE LPAREN condition RPAREN LBRACE body RBRACE
;

condition:
    ID
  | NUMBER
;

body:
    /* allow zero or more statements inside */
    stmt_list
;

stmt_list:
    stmt_unit
  | stmt_list stmt_unit
;

stmt_unit:
    ID SEMI
  | NUMBER SEMI
;

%%

void yyerror(const char *s) {
    printf("Invalid while loop syntax\n");
    exit(1);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file.c>\n", argv[0]);
        exit(1);
    }

    // Open the file passed as the first argument
    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror("Unable to open file");
        exit(1);
    }

    // Set yyin to the file pointer
    yyin = file;

    // Parse the input file
    yyparse();

    // Close the file after parsing
    fclose(file);
    return 0;
}
