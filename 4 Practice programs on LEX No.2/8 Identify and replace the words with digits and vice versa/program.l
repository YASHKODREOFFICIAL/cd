%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

const char *digit_to_word[] = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};

const char* word_to_digit(const char *word) {
    if (strcmp(word, "zero") == 0) return "0";
    if (strcmp(word, "one") == 0) return "1";
    if (strcmp(word, "two") == 0) return "2";
    if (strcmp(word, "three") == 0) return "3";
    if (strcmp(word, "four") == 0) return "4";
    if (strcmp(word, "five") == 0) return "5";
    if (strcmp(word, "six") == 0) return "6";
    if (strcmp(word, "seven") == 0) return "7";
    if (strcmp(word, "eight") == 0) return "8";
    if (strcmp(word, "nine") == 0) return "9";
    return NULL;
}

%}

%option noyywrap

%%

[0-9]   { 
            printf("%s", yytext); 
          }

[ \t\n]+  { }

[a-zA-Z]+ {
            const char *digit = word_to_digit(yytext);
            if (digit) {
                printf("%s", digit); 
            } else {
                printf("%s", yytext); 
            }
          }

%%

int main() {
    yylex();
    return 0;
}
