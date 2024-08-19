package sql.types;

/**
 * Class that models a SQL Boolean.
 */
public class SQLBoolean extends SQLType {

    private final Boolean value;

    /**
     * Constructor for SQLBool.
     * @param value the value
     */
    public SQLBoolean(Boolean value) {
        this.value = value;
    }

    @Override
    public Boolean toBool() {
        return value;
    }

    @Override
    public Double toDouble() {
        return value ? 1.0 : 0.0;
    }

    @Override
    public String toString() {
        return value.toString();
    }

}
