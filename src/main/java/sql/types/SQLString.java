package sql.types;

/**
 * Class that models a SQL String.
 */
public class SQLString extends SQLType {

    private final String value;

    /**
     * Constructor for SQLString.
     * @param value the value
     */
    public SQLString(String value) {
        this.value = value;
    }

    @Override
    public Boolean toBool() {
        return value != null && !value.isEmpty();
    }

    @Override
    public Double toDouble() {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return Double.NaN;
        }
    }

    @Override
    public String toString() {
        return value;
    }
}
