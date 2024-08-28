package sql.errors;

/**
 * Represent an exception that is thrown when a constraint is violated.
 */
public class EntityNotFound extends SQLException {

    /**
     * Constructs a new EntityNotFound.
     * @param message the message to be displayed when the exception is thrown
     */
    public EntityNotFound(final String message) {
        super(message);
    }
}
