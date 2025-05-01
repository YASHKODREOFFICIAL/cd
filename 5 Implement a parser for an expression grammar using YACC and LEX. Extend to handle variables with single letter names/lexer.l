%{
#include "y.tab.h"
#include <stdlib.h>
%}

%%
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
[a-zA-Z]    { yylval = yytext[0]; return VARIABLE; }
"="         { return ASSIGN; }
[+\-*/]     { return yytext[0]; }
[ \t\n]     { /* Skip whitespace */ }
.           { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
