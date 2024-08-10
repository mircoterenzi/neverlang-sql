package sql;

import java.util.Optional;

/**
 * Represents a column in a SQL table.
 */
public class Column {

    /**
     * The data type of the column.
     */
    private Types type;

    /**
     * Indicates whether the column allows null values.
     */
    private boolean isNotNull;

    /**
     * Indicates whether the column values must be unique.
     */
    private boolean isUnique;

    /**
     * The aggregate function to be applied to the column.
     */
    private Optional<Aggregates> aggregate;

    /**
     * Constructs a new column object with the specified data type, nullability, and uniqueness.
     * @param type the data type of the column
     * @param isNotNull indicates whether the column allows null values
     * @param isUnique indicates whether the column values must be unique
     */
    public Column(Types type, boolean isNotNull, boolean isUnique, Optional<Aggregates> aggregate) {
        this.type = type;
        this.isNotNull = isNotNull;
        this.isUnique = isUnique;
    }

    /**
     * @return the data type of the column
     */
    public Types getType() {
        return type;
    }

    /**
     * @return true if the column allows null values, false otherwise
     */
    public boolean isNotNull() {
        return isNotNull;
    }

    /**
     * @return true if the column values must be unique, false otherwise
     */
    public boolean isUnique() {
        return isUnique;
    }

    /**
     * @return the aggregate function to be applied to the column
     */
    public Optional<Aggregates> getAggregate() {
        return aggregate;
    }

}
