import java.io.*;
import java.util.*;
import java.util.regex.*;

class Token {
    String type;
    String value;
    int lineNumber;

    Token(String type, String value, int lineNumber) {
        this.type = type;
        this.value = value;
        this.lineNumber = lineNumber;
    }
}

public class SQLLexer {

    static final Set<String> keywords = new HashSet<>(Arrays.asList(
        "SELECT", "FROM", "WHERE", "INSERT", "INTO", "VALUES", "UPDATE",
        "SET", "DELETE", "AND", "OR", "NOT", "CREATE", "TABLE", "DROP"
    ));

    static final Set<Character> operators = new HashSet<>(Arrays.asList('=', '<', '>', '+', '-', '*', '/', '!'));
    static final Set<Character> symbols = new HashSet<>(Arrays.asList('(', ')', ',', ';'));

    public static void main(String[] args) {
        List<Token> tokens = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader("input.sql"))) {
            String line;
            int lineNum = 0;

            while ((line = reader.readLine()) != null) {
                lineNum++;
                int i = 0;
                while (i < line.length()) {
                    char ch = line.charAt(i);

                    if (Character.isWhitespace(ch)) {
                        i++;
                        continue;
                    }

                    if (Character.isLetter(ch) || ch == '_') {
                        StringBuilder sb = new StringBuilder();
                        while (i < line.length() && (Character.isLetterOrDigit(line.charAt(i)) || line.charAt(i) == '_')) {
                            sb.append(line.charAt(i++));
                        }
                        String word = sb.toString();
                        String upper = word.toUpperCase();
                        tokens.add(new Token(keywords.contains(upper) ? "KEYWORD" : "IDENTIFIER", word, lineNum));
                    } else if (Character.isDigit(ch)) {
                        StringBuilder sb = new StringBuilder();
                        while (i < line.length() && Character.isDigit(line.charAt(i))) {
                            sb.append(line.charAt(i++));
                        }
                        tokens.add(new Token("NUMBER", sb.toString(), lineNum));
                    } else if (ch == '\'') {
                        i++;
                        StringBuilder sb = new StringBuilder();
                        while (i < line.length() && line.charAt(i) != '\'') {
                            sb.append(line.charAt(i++));
                        }
                        i++; // consume closing quote
                        tokens.add(new Token("STRING_LITERAL", sb.toString(), lineNum));
                    } else if (operators.contains(ch)) {
                        String op = String.valueOf(ch);
                        i++;
                        if ((op.equals("<") || op.equals(">") || op.equals("!")) && i < line.length() && line.charAt(i) == '=') {
                            op += line.charAt(i++);
                        }
                        tokens.add(new Token("OPERATOR", op, lineNum));
                    } else if (symbols.contains(ch)) {
                        tokens.add(new Token("SYMBOL", String.valueOf(ch), lineNum));
                        i++;
                    } else {
                        tokens.add(new Token("UNKNOWN", String.valueOf(ch), lineNum));
                        i++;
                    }
                }
            }

            // Output table
            System.out.println("+----------+-----------------+---------------------+");
            System.out.println("| Line No. | Token Type      | Token Value         |");
            System.out.println("+----------+-----------------+---------------------+");
            for (Token token : tokens) {
                System.out.printf("| %8d | %-15s | %-19s |\n",
                    token.lineNumber, token.type, token.value);
            }
            System.out.println("+----------+-----------------+---------------------+");

        } catch (IOException e) {
            System.out.println("Error reading input.sql: " + e.getMessage());
        }
    }
}
