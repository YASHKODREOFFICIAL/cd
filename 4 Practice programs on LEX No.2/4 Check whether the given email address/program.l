%{
#include <stdio.h>
#include <string.h>

char user_input[100];
int is_valid = 0;
%}

%option noyywrap

%%
[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,} {
    is_valid = 1;
}
.|\n { }  // Ignore everything else
%%

int main() {
    printf("Enter email: ");
    fgets(user_input, sizeof(user_input), stdin);
    user_input[strcspn(user_input, "\n")] = 0; // Remove newline

    YY_BUFFER_STATE buffer = yy_scan_string(user_input);
    yylex();
    yy_delete_buffer(buffer);

    if (is_valid)
        printf("Valid email address: %s\n", user_input);
    else
        printf("Invalid email address\n");

    return 0;
}
