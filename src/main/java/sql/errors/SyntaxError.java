package sql.errors;

/**
 * Represents a specific exception relating to syntax errors.
 */
public class SyntaxError extends SQLException {

    /**
     * Constructs a new SyntaxError.
     * @param message the message to be displayed when the exception is thrown
     */
    public SyntaxError(final String message) {
        super(message);
    }
}
