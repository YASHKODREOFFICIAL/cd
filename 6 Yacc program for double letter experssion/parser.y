%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylex();
    void yyerror(const char *s);

    // Symbol table for up to 26*26 variable names
    int sym[26][26] = {0};
%}

%union {
    int num;
    char* var;
}

%token <num> NUMBER
%token <var> VARIABLE
%type <num> expr

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

program:
    program statement '\n'
    | statement '\n'
    ;

statement:
    expr {
        printf("Result: %d\n", $1);
    }
    | VARIABLE '=' expr {
        int i = $1[0] - 'a';
        int j = ($1[1] != '\0') ? $1[1] - 'a' : 0;
        sym[i][j] = $3;
        if ($1[1] != '\0')
            printf("%c%c = %d\n", $1[0], $1[1], $3);
        else
            printf("%c = %d\n", $1[0], $3);
        free($1);
    }
    ;

expr:
    expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr {
        if ($3 == 0) yyerror("division by zero");
        else $$ = $1 / $3;
    }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')' { $$ = $2; }
    | NUMBER { $$ = $1; }
    | VARIABLE {
        int i = $1[0] - 'a';
        int j = ($1[1] != '\0') ? $1[1] - 'a' : 0;
        $$ = sym[i][j];
        free($1);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter expressions (e.g., a=31+42*23 or ad+be*cf):\n");
    return yyparse();
}
