%{
#include <stdio.h>
#include <string.h>
int line_num = 1;
int token_count = 0;

void print_token(const char* lexeme, const char* token, const char* value) {
    printf("%-5d %-10s %-12s %-10s\n", line_num, lexeme, token, value);
    token_count++;
}
%}

%%
"int"|"float"|"return"|"if"|"else"|"while"|"for"     { print_token(yytext, "Keyword", "-"); }
[a-zA-Z_][a-zA-Z0-9_]*                               { print_token(yytext, "Identifier", "-"); }
[0-9]+                                               { print_token(yytext, "Integer", yytext); }
\"([^\\\"]|\\.)*\"                                   { print_token(yytext, "String", yytext); }
"=="|"!="|">="|"<="|"="|"+"|"-"|"*"|"/"|"%"          { print_token(yytext, "Operator", "-"); }
[(){};,]                                             { print_token(yytext, "Delimiter", "-"); }
[ \t]+                                               { /* skip whitespace */ }
\n                                                   { line_num++; }
.                                                    { print_token(yytext, "Unknown", "-"); }
%%

int yywrap() { return 1; }

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("File open failed");
        return 1;
    }

    yyin = fp;

    printf("Line  Lexeme     Token        Value\n");
    printf("----- ---------- ------------ ----------\n");

    yylex();

    printf("\nTotal tokens: %d\n", token_count);

    fclose(fp);
    return 0;
}
