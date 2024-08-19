package sql.types;

/**
 * Class that models a SQL Integer.
 */
public class SQLInteger extends SQLType {

    private final Integer value;

    /**
     * Constructor for SQLInteger.
     * @param value the value
     */
    public SQLInteger(Integer value) {
        this.value = value;
    }

    @Override
    public Boolean toBool() {
        return value != null && value != 0;
    }

    @Override
    public Double toDouble() {
        return value.doubleValue();
    }

    @Override
    public String toString() {
        return value.toString();
    }
    
}
