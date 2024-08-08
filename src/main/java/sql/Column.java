package sql;

import java.util.List;
import java.util.ArrayList;

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
     * The list of values associated with the column.
     */
    private List<Object> values = new ArrayList<>();

    /**
     * Constructs a new column object with the specified data type, nullability, and uniqueness.
     * @param type the data type of the column
     * @param isNotNull indicates whether the column allows null values
     * @param isUnique indicates whether the column values must be unique
     */
    public Column(Types type, boolean isNotNull, boolean isUnique) {
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
     * @return the number of values in the column
     */
    public int getSize() {
        return values.size();
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
     * Adds the value to the column.
     * @param elements the value to be added
     */
    public void add(Object element) {
        values.add(element);    //TODO: add a check on whether the value is unique and/or not-null (if necessary)
    }

    /**
     * Adds a list of values to the column.
     * @param elements the list of values to be added
     */
    public void addAll(List<Object> elements) {
        values.addAll(elements);
    }

    /**
     * Retrieves the object at the specified index.
     * @param index the index of the object to retrieve
     * @return the object at the specified index
     */
    public Object get(int index) {
        return values.get(index);
    }

    /**
     * @return the list of values associated with the column
     */
    public List<Object> getAll() {
        return values;
    }

}
