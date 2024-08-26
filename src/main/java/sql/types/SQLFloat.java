package sql.types;

/**
 * Class that models a SQL Float.
 */
public class SQLFloat extends SQLType {
    /**
     * The value of the SQLBoolean.
     */
    private final Double value;

    /**
    * Constructor for SQLFloat.
    * @param givenValue the value
    */
    public SQLFloat(final Double givenValue) {
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
        return value;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return value.toString();
    }
}
