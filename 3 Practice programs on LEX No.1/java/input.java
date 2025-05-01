// This is a simple Java program

public class Main {
    public static void main(String[] args) {
        int x = 10;
        float y = 20.5f;
        
        // Performing arithmetic operations
        int sum = x + (int) y; // Casting float to int
        
        if (sum > 10) {
            System.out.println("Sum is greater than 10");
        } else {
            System.out.println("Sum is less than or equal to 10");
        }
    }
}
