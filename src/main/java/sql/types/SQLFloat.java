package sql.types;

/**
 * Class that models a SQL Float.
 */
public class SQLFloat extends SQLType {
    
    private final Float value;

    /**
    * Constructor for SQLFloat.
    * @param value the value
    */
    public SQLFloat(Float value) {
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
