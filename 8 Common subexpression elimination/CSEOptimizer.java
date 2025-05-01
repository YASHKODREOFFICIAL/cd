import java.util.*;

// Class representing a quadruple
class Quad {
    String op, arg1, arg2, res;

    Quad(String op, String arg1, String arg2, String res) {
        this.op = op;
        this.arg1 = arg1;
        this.arg2 = arg2;
        this.res = res;
    }
}

public class CSEOptimizer {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter number of quadruples: ");
        int n = sc.nextInt();
        List<Quad> quads = new ArrayList<>();

        System.out.println("\nEnter each quadruple in the format: op arg1 arg2 result");
        for (int i = 0; i < n; i++) {
            String op = sc.next();
            String arg1 = sc.next();
            String arg2 = sc.next();
            String res = sc.next();
            quads.add(new Quad(op, arg1, arg2, res));
        }

        // Map expression key -> result variable holding its value
        Map<String, String> exprMap = new HashMap<>();
        List<Quad> optimized = new ArrayList<>();

        for (Quad q : quads) {
            String key = q.op + " " + q.arg1 + " " + q.arg2;
            if (exprMap.containsKey(key)) {
                // Found a common sub-expression: replace with simple assignment
                String prevRes = exprMap.get(key);
                // Use empty string for arg2 in assignment
                optimized.add(new Quad("=", prevRes, "", q.res));
            } else {
                // New expression: keep and record its result
                exprMap.put(key, q.res);
                optimized.add(q);
            }
        }
        System.out.println("\nOptimized Quadruples:");
        System.out.println("op\targ1\targ2\tresult");
        for (Quad q : optimized) {
            String arg2 = (q.arg2 == null || q.arg2.isEmpty()) ? "-" : q.arg2;
            System.out.println(q.op + "\t" + q.arg1 + "\t" + arg2 + "\t" + q.res);
        }

        sc.close();
    }
}