#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#define MAX_TOKEN 256

const char *keywords[] = {
    "SELECT", "FROM", "WHERE", "INSERT", "INTO", "VALUES",
    "UPDATE", "SET", "DELETE", "AND", "OR", "NOT", "CREATE", "TABLE", "DROP"
};
int numKeywords = sizeof(keywords) / sizeof(keywords[0]);

int isKeyword(const char *str) {
    for (int i = 0; i < numKeywords; i++) {
        if (strcasecmp(str, keywords[i]) == 0) return 1;
    }
    return 0;
}

void printToken(int line, const char *type, const char *value) {
    printf("| %8d | %-15s | %-19s |\n", line, type, value);
}

int main() {
    FILE *file = fopen("input.sql", "r");
    if (!file) {
        printf("Error opening file.\n");
        return 1;
    }

    printf("+----------+-----------------+---------------------+\n");
    printf("| Line No. | Token Type      | Token Value         |\n");
    printf("+----------+-----------------+---------------------+\n");

    char ch, token[MAX_TOKEN];
    int i, line = 1;

    while ((ch = fgetc(file)) != EOF) {
        if (isspace(ch)) {
            if (ch == '\n') line++;
            continue;
        }

        if (isalpha(ch) || ch == '_') {
            i = 0;
            token[i++] = ch;
            while ((ch = fgetc(file)) != EOF && (isalnum(ch) || ch == '_')) {
                token[i++] = ch;
            }
            token[i] = '\0';
            if (ch != EOF) ungetc(ch, file);
            printToken(line, isKeyword(token) ? "KEYWORD" : "IDENTIFIER", token);
        }
        else if (isdigit(ch)) {
            i = 0;
            token[i++] = ch;
            while ((ch = fgetc(file)) != EOF && isdigit(ch)) {
                token[i++] = ch;
            }
            token[i] = '\0';
            if (ch != EOF) ungetc(ch, file);
            printToken(line, "NUMBER", token);
        }
        else if (ch == '\'') {
            i = 0;
            while ((ch = fgetc(file)) != EOF && ch != '\'') {
                token[i++] = ch;
            }
            token[i] = '\0';
            printToken(line, "STRING_LITERAL", token);
        }
        else if (strchr("=<>!*/+-", ch)) {
            token[0] = ch;
            token[1] = '\0';
            char next = fgetc(file);
            if ((ch == '<' || ch == '>' || ch == '!') && next == '=') {
                token[1] = next;
                token[2] = '\0';
            } else {
                if (next != EOF) ungetc(next, file);
            }
            printToken(line, "OPERATOR", token);
        }
        else if (strchr("(),;", ch)) {
            token[0] = ch;
            token[1] = '\0';
            printToken(line, "SYMBOL", token);
        }
        else {
            token[0] = ch;
            token[1] = '\0';
            printToken(line, "UNKNOWN", token);
        }
    }

    printf("+----------+-----------------+---------------------+\n");
    fclose(file);
    return 0;
}
