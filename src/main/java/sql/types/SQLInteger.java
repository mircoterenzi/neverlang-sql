package sql.types;

/**
 * Class that models a SQL Integer.
 */
public class SQLInteger extends SQLType {
    /**
     * The value of the SQLBoolean.
     */
    private final Integer value;

    /**
     * Constructor for SQLInteger.
     * @param givenValue the value
     */
    public SQLInteger(final Integer givenValue) {
        value = givenValue;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Boolean toBool() {
        return value != null && value != 0;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Double toDouble() {
        return value.doubleValue();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return value.toString();
    }
}
