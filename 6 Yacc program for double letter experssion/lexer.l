%{
    #include "y.tab.h"
    #include <string.h>
    #include <stdlib.h>

    extern YYSTYPE yylval;
%}

%%

[a-z]{1,2} {
    yylval.var = strdup(yytext);
    return VARIABLE;
}

[0-9]+ {
    yylval.num = atoi(yytext);
    return NUMBER;
}

[ \t]          { /* skip whitespace */ }

\n             { return '\n'; }

[-+*/=()]      { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
