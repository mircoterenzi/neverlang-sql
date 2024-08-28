package sql.errors;

/**
 * Represents a specific exception relating to data inconsistency.
 * It is thrown when an attempt is made to enter invalid values or
 * the database definition is not respected.
 */
public class DataInconsistency extends SQLException {

    /**
     * Constructs a new DataIntegrityViolation.
     * @param message the message to be displayed when the exception is thrown
     */
    public DataInconsistency(final String message) {
        super(message);
    }
}
