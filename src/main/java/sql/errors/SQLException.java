package sql.errors;

/**
 * Exception that is thrown when an error occurs during
 * the execution of a SQL query.
 */
public class SQLException extends RuntimeException {

    /**
     * Constructs a new SQLException.
     * @param message the message to be displayed when the exception is thrown
     */
    public SQLException(final String message) {
        super(message);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public synchronized Throwable fillInStackTrace() {
        return this;
    }

}
