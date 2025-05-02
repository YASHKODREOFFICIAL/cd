%{
#include "y.tab.h"
#include <stdio.h>
%}

%%

"while"         { return WHILE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
";"             { return SEMI; }
"exit"          { return EXIT; }

[0-9]+          { return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { return ID; }

[ \t\n]+        { /* skip whitespace */ }
.               { return *yytext; }

%%

int yywrap() {
    return 1;
}
