package sql.errors;

/**
 * Represent an exception that is thrown when a constraint is violated.
 */
public class ConstraintViolation extends SQLException {

    /**
     * Constructs a new ConstraintViolation.
     * @param message the message to be displayed when the exception is thrown
     */
    public ConstraintViolation(final String message) {
        super(message);
    }
}
