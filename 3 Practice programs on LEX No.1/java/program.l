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

"int"|"float"|"double"|"char"|"return"|"if"|"else"|"for"|"while"|"break"|"continue" {
    struct token t;
    strcpy(t.type, "KEYWORD");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    struct token t;
    strcpy(t.type, "IDENTIFIER");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

"="|"+="|"-="|"*="|"/="|"=="|"<="|">="|"!="|"<"|">"|"+"|"-"|"*"|"/" {
    struct token t;
    strcpy(t.type, "OPERATOR");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

[0-9]+ {
    struct token t;
    strcpy(t.type, "LITERAL");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

"//"[^'\n']* {
    struct token t;
    strcpy(t.type, "COMMENT");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

"/*"[^*]*\*+([^*/][^*]*\*+)*"/" {
    struct token t;
    strcpy(t.type, "COMMENT");
    strcpy(t.value, yytext);
    t.line = line_number;
    print_token(t);
}

"(" {
    struct token t;
    strcpy(t.type, "PUNCTUATION");
    strcpy(t.value, "(");
    t.line = line_number;
    print_token(t);
}

")" {
    struct token t;
    strcpy(t.type, "PUNCTUATION");
    strcpy(t.value, ")");
    t.line = line_number;
    print_token(t);
}

"{" {
    struct token t;
    strcpy(t.type, "PUNCTUATION");
    strcpy(t.value, "{");
    t.line = line_number;
    print_token(t);
}

"}" {
    struct token t;
    strcpy(t.type, "PUNCTUATION");
    strcpy(t.value, "}");
    t.line = line_number;
    print_token(t);
}

";" {
    struct token t;
    strcpy(t.type, "PUNCTUATION");
    strcpy(t.value, ";");
    t.line = line_number;
    print_token(t);
}

"," {
    struct token t;
    strcpy(t.type, "PUNCTUATION");
    strcpy(t.value, ",");
    t.line = line_number;
    print_token(t);
}

\n {
    line_number++;
}


[ \t]+  { }

. { }

%%

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        perror("File opening failed");
        return 1;
    }

    printf("| %-15s | %-15s | %-5s |\n", "Type", "Value", "Line");
    printf("|-----------------|-----------------|-------|\n");

    yyin = file;
    yylex();
    fclose(file);

    return 0;
}
