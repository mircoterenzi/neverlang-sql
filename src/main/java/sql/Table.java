package sql;

import java.util.List;
import java.util.LinkedHashMap;
import java.util.stream.Collectors;

/**
 * Represents a table in a SQL database.
 */
public class Table {

    /**
     * The list of columns that compose the table.
     */
    private LinkedHashMap<String, Column> columns;

    /**
     * Constructor for the Table class.
     */
    public Table() {
        columns = new LinkedHashMap<>();
    }

    /**
     * @return the list of column names.
     */
    public List<String> getHeadings() {
        return columns.keySet().stream().collect(Collectors.toList());
    }

    /**
     * Adds a new column to the table.
     * @param name the name of the column
     * @param type the data type of the column
     * @param isNotNull specifies if the column allows null values or not
     * @param isUnique specifies if the column values must be unique or not
     * @throws IllegalArgumentException if the given name is already used for another column
     */
    public void add(String name, Types type, Boolean isNotNull, Boolean isUnique) {
        if (columns.containsKey(name)) {
            throw new IllegalArgumentException("This name it's used to identify another column");
        } else {
            columns.put(name, new Column(type, isNotNull, isUnique));
        }
    }

    /**
     * Adds a new column to the table.
     * @param name the name of the column
     * @param type the data type of the column
     * @throws IllegalArgumentException if the given name is already used for another column
     */
    public void add(String name, Types type) {
        add(name, type, false, false);
    }

    /**
     * Removes a column from the table.
     * @param name the name of the column
     */
    public void remove(String name) {
        columns.remove(name);
    }

    /**
     * Adds data to a specific list of columns.
     * @param headings list of column names
     * @param values list of data to be added to each column
     */
    public void put(List<String> headings, List<Object> values) {
        if (headings.size() != values.size()) { // The list of data has to be the same lenght of the list of column names.
            throw new IllegalArgumentException(
                "The number of variables and the number of values to be assigned to them are different"
            );
        }
        // For each column, add the data to the list of data.
        for (int i=0; i<values.size(); i++) {
            var heading = headings.get(i);

            if (columns.containsKey(heading)) {
                var column = columns.get(heading);

                if (column.getType().checkType(values.get(i)) || values.get(i) == null) {
                    column.add(values.get(i));
                    columns.put(heading, column);
                } else {
                    throw new IllegalArgumentException(
                        "The value " + values.get(i) + " is not of the type " + column.getType()
                    );
                }
            } else {
                throw new IllegalArgumentException(
                    "Column \"" + heading + "\" does not exist"
                );
            }
        }
        // If there are columns that are not in the list, add null values.
        for (var columnName : columns.keySet()) {
            if (!headings.contains(columnName)) {
                headings.add(null);
            }
        }
    }

    /**
     * Adds data to the table.
     * @param values list of data to be added to the table
     */
    public void put(List<Object> values) {
        put(getHeadings(), values);
    }

    /**
     * Gets data from a specific list of columns.
     * @param keys the list of column names.
     * @return the list of data of the columns
     */
    public List<List<Object>> get(List<String> keys) {
        return keys.stream()
                .map(key -> columns.get(key).getAll())
                .collect(Collectors.toList());
    }

    /**
     * Gets datas from the table.
     * @return the list of data of the table.
     */
    public List<List<Object>> get() {
        return get(getHeadings());
    }

    /**
     * Return a string representation of the Table.
     */
    public String toString() {
        var sb = new StringBuilder();
        var keys = getHeadings();

        for (int i=0; i<columns.get(keys.get(0)).getSize(); i++) {
            for (var key : keys) {
                sb.append(columns.get(key).get(i) + " ");
            }
            sb.append("\n");
        }
        return sb.toString();
    }
}
