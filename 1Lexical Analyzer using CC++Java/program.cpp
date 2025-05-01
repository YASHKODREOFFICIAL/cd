#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cctype>
#include <unordered_set>
#include <iomanip>
#include <vector>

using namespace std;

enum TokenType {
    KEYWORD, IDENTIFIER, NUMBER, STRING_LITERAL, OPERATOR, SYMBOL, UNKNOWN, END
};

struct Token {
    TokenType type;
    string value;
    int lineNumber;
};

unordered_set<string> keywords = {
    "SELECT", "FROM", "WHERE", "INSERT", "INTO", "VALUES", "UPDATE",
    "SET", "DELETE", "AND", "OR", "NOT", "CREATE", "TABLE", "DROP"
};

unordered_set<char> operators = {'=', '<', '>', '+', '-', '*', '/', '!'};
unordered_set<char> symbols = {'(', ')', ',', ';'};

// Converts enum TokenType to string
string tokenTypeToString(TokenType type) {
    switch (type) {
        case KEYWORD: return "KEYWORD";
        case IDENTIFIER: return "IDENTIFIER";
        case NUMBER: return "NUMBER";
        case STRING_LITERAL: return "STRING_LITERAL";
        case OPERATOR: return "OPERATOR";
        case SYMBOL: return "SYMBOL";
        case UNKNOWN: return "UNKNOWN";
        case END: return "END";
        default: return "INVALID";
    }
}

class Lexer {
    string input;
    size_t pos;
    size_t length;
    int line;

public:
    Lexer(string str) : input(str), pos(0), length(str.length()), line(1) {}

    char peek() { return pos < length ? input[pos] : '\0'; }
    char get() {
        char c = pos < length ? input[pos++] : '\0';
        if (c == '\n') line++;
        return c;
    }

    void skipWhitespace() {
        while (isspace(peek())) get();
    }

    Token getNextToken() {
        skipWhitespace();
        char current = peek();
        if (current == '\0') return {END, "", line};

        if (isalpha(current) || current == '_') {
            string value;
            while (isalnum(peek()) || peek() == '_') value += get();
            string upper = value;
            for (auto& c : upper) c = toupper(c);
            if (keywords.count(upper)) return {KEYWORD, upper, line};
            return {IDENTIFIER, value, line};
        }

        if (isdigit(current)) {
            string value;
            while (isdigit(peek())) value += get();
            return {NUMBER, value, line};
        }

        if (current == '\'') {
            get(); // consume '
            string value;
            while (peek() != '\'' && peek() != '\0') value += get();
            if (peek() == '\'') get(); // closing '
            return {STRING_LITERAL, value, line};
        }

        if (operators.count(current)) {
            string op(1, get());
            if ((op == "<" || op == ">" || op == "!") && peek() == '=') op += get();
            return {OPERATOR, op, line};
        }

        if (symbols.count(current)) return {SYMBOL, string(1, get()), line};

        return {UNKNOWN, string(1, get()), line};
    }
};

int main() {
    ifstream file("input.sql");
    if (!file) {
        cerr << "Error: Cannot open file 'input.sql'" << endl;
        return 1;
    }

    stringstream buffer;
    buffer << file.rdbuf();
    string sql = buffer.str();

    Lexer lexer(sql);
    vector<Token> tokens;
    Token token;

    while ((token = lexer.getNextToken()).type != END) {
        tokens.push_back(token);
    }

    // Output tokens in table format
    cout << "+----------+-----------------+---------------------+" << endl;
    cout << "| Line No. | Token Type      | Token Value         |" << endl;
    cout << "+----------+-----------------+---------------------+" << endl;
    for (const auto& tok : tokens) {
        cout << "| " << setw(8) << tok.lineNumber << " | "
             << setw(15) << tokenTypeToString(tok.type) << " | "
             << setw(19) << tok.value << " |" << endl;
    }
    cout << "+----------+-----------------+---------------------+" << endl;

    return 0;
}
