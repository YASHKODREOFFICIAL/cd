%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_VARS 26  // Assume variables are single letters (a-z)

int yylex();
void yyerror(const char *s);

int symbolTable[MAX_VARS];  // Symbol table for storing values of variables
int getVariableIndex(char var) { return var - 'a'; }

%}

%token NUMBER
%token VARIABLE
%token ASSIGN

%left '+' '-'
%left '*' '/'

%%
program:
    statement
  | program statement
  ;

statement:
    VARIABLE ASSIGN expression     { 
                                        int idx = getVariableIndex($1);
                                        symbolTable[idx] = $3;
                                      }
  ;

expression:
    expression '+' expression      { $$ = $1 + $3; }
  | expression '-' expression      { $$ = $1 - $3; }
  | expression '*' expression      { $$ = $1 * $3; }
  | expression '/' expression      { if ($3 == 0) { yyerror("Division by zero"); } else { $$ = $1 / $3; } }
  | VARIABLE                       { $$ = symbolTable[getVariableIndex($1)]; }
  | NUMBER                         { $$ = $1; }
  | '(' expression ')'             { $$ = $2; }
  ;

%%

int main(void) {
    // Initialize symbol table to -1 (indicating uninitialized variables)
    for (int i = 0; i < MAX_VARS; i++) {
        symbolTable[i] = -1;
    }

    printf("Enter expressions:\n");
    yyparse();

    // Print the final values of all variables after parsing
    for (int i = 0; i < MAX_VARS; i++) {
        if (symbolTable[i] != -1) {  // Only print variables that have been assigned a value
            printf("%c = %d\n", 'a' + i, symbolTable[i]);
        }
    }

    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
