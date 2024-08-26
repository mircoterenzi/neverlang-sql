package sql.types;

public abstract class SQLType {
    /**
     * Converts the SQLType to a boolean.
     * @return the boolean value of the SQLType
     */
    public abstract Boolean toBool();

    /**
     * Converts the SQLType to a number.
     * @return the number value of the SQLType
     */
    public abstract Double toDouble();

    /**
     * Converts the SQLType to a string.
     * @return the string value of the SQLType
     */
    @Override
    public abstract String toString();

    /**
     * Compares this SQLType to another SQLType.
     * @param other SQLType to compare to
     * @return 0 if the SQLTypes are equal,
     * a positive number if this SQLType is greater
     * and a negative number if this SQLType is less
     */
    public Integer compareTo(final SQLType other) {
        return this.toDouble().compareTo(other.toDouble());
    }

}
