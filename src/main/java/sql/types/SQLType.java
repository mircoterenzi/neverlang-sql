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

    @Override
    public abstract String toString();

    /**
     * Compares this SQLType to another SQLType.
     * @param other the other SQLType to compare to
     * @return 0 if the SQLTypes are equal, a positive number if this SQLType is greater, and a negative number if this SQLType is less
     */
    public Integer compareTo(SQLType other) {
        return this.toDouble().compareTo(other.toDouble());
    }

    @Override
    public boolean equals(Object other) {
        return this.toString().equals(other.toString());
    }
}
