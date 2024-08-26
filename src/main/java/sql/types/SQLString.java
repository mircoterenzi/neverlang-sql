package sql.types;

/**
 * Class that models a SQL String.
 */
public class SQLString extends SQLType {
    /**
     * The value of the SQLBoolean.
     */
    private final String value;

    /**
     * Constructor for SQLString.
     * @param givenValue the value
     */
    public SQLString(final String givenValue) {
        value = givenValue;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Boolean toBool() {
        return value != null && !value.isEmpty();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Double toDouble() {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return Double.NaN;
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return value;
    }
}
