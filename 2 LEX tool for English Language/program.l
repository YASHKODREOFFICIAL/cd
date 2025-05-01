%{
#include <stdio.h>
#include <string.h>
int lineno = 1;
%}

%option noyywrap

%%
[\n]            { lineno++; }

[ \t\r]+        { /* skip whitespace */ }

[Tt]he|[Aa]n|[Aa] { printf("Line %d: Lexeme: %s Token: ARTICLE\n", lineno, yytext); }
[Bb]oy|[Gg]irl|[Dd]og|[Cc]at|[Pp]eople|[Tt]able|[C]hild|[S]tudent|[P]arent|[H]ouse {
                    printf("Line %d: Lexeme: %s Token: NOUN\n", lineno, yytext); 
                }

[Ii]s|[Aa]re|[Ww]as|[Ww]ere|[Aa]m|[Pp]laying|[Rr]unning|[Jj]umping|[Gg]o|[D]o|[C]reate {
                    printf("Line %d: Lexeme: %s Token: VERB\n", lineno, yytext);
                }

[Uu]nder|[Oo]ver|[B]etween|[I]n|[O]n|[A]t|[B]y|[A]bout|[F]or|[W]ith|[F]rom|[T]o { 
                    printf("Line %d: Lexeme: %s Token: PREPOSITION\n", lineno, yytext);
                }

[Oo]f|[Aa]nd|[Bb]ut|[Oo]r|[N]or|[Y]et|[S]o|[T]hough|[W]hile|[I]f|[T]hen {
                    printf("Line %d: Lexeme: %s Token: CONJUNCTION\n", lineno, yytext);
                }

[Qq]uick|[S]low|[L]arge|[S]mall|[T]all|[T]hin|[G]ood|[B]ad|[E]xciting|[I]nteresting|[F]ast|[L]ovely {
                    printf("Line %d: Lexeme: %s Token: ADJECTIVE\n", lineno, yytext);
                }

[Q]uickly|[S]lowly|[L]oudly|[F]ast|[R]apidly|[H]appily|[S]adly|[I]nteresting|[G]ood|[B]ad {
                    printf("Line %d: Lexeme: %s Token: ADVERB\n", lineno, yytext);
                }

[a-zA-Z]+        { 
                    if (strstr(yytext, "ing") != NULL) {
                        printf("Line %d: Lexeme: %s Token: VERB\n", lineno, yytext);
                    } else {
                        printf("Line %d: Lexeme: %s Token: NOUN\n", lineno, yytext);
                    }
                }

.               { printf("Line %d: Lexeme: %s Token: UNKNOWN\n", lineno, yytext); }
%%

int main() {
    printf("Enter text for lexical analysis:\n");
    yylex();
    return 0;
}
