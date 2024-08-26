package sql.types;

/**
 * Class that models a SQL Boolean.
 */
public class SQLBoolean extends SQLType {
    /**
     * The value of the SQLBoolean.
     */
    private final Boolean value;

    /**
     * Constructor for SQLBool.
     * @param givenValue the value
     */
    public SQLBoolean(final Boolean givenValue) {
        value = givenValue;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Boolean toBool() {
        return value;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Double toDouble() {
        return value ? 1.0 : 0.0;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return value.toString();
    }

}
