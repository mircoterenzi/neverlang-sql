package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.stream.Collectors;

/**
 * Class used to store a table of data.
 */
public class Table {
    private LinkedHashMap<String, List<Object>> columns;
    private LinkedHashMap<String, Types> types;

    /**
     * Constructor for the Table class.
     */
    public Table() {
        columns = new LinkedHashMap<>();
        types = new LinkedHashMap<>();
    }

    /**
     * Function used to add a column to the table.
     * @param name the name of the column.
     * @param type the type of vaules contained in the column.
     */
    public void addColumn(String name, Types type) {
        columns.put(name, new ArrayList<>());
        types.put(name, type);
    }

    /**
     * Function used to remove a column from the table.
     * @param name the name of the column.
     */
    public void removeColumn(String name) {
        columns.remove(name);
        types.remove(name);
    }

    /**
     * Function used to add data to a list of column.
     * @param headings list of column names.
     * @param values list of data to be added to each column.
     */
    public void addValues(List<String> headings, List<Object> values) {
        if (headings.size() != values.size()) { // The list of data has to be the same lenght of the list of column names.
            throw new IllegalArgumentException(
                "The number of variables and the number of values to be assigned to them are different"
            );
        }
        // For each column, add the data to the list of data.
        for (int i=0; i<values.size(); i++) {
            var heading = headings.get(i);

            if (columns.containsKey(heading) && types.containsKey(heading)) {
                var columnValues = columns.get(heading);

                columnValues.add(types.get(heading).convert((String) values.get(i)));
                columns.put(heading, columnValues);
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
     * Function used to add data to the table.
     * @param values list of data to be added to the table.
     */
    public void addValues(List<Object> values) {
        addValues(getKeyLists(), values);
    }

    /**
     * Function used to get the column names.
     * @return the list of column names.
     */
    public List<String> getKeyLists() {
        return columns.keySet().stream().collect(Collectors.toList());
    }

    /**
     * Function used to get data from a list of columns.
     * @param keys the list of column names.
     * @return the list of data of the columns.
     */
    public List<List<Object>> getValues(List<String> keys) {
        return keys.stream()
                .map(key -> columns.get(key))
                .collect(Collectors.toList());
    }

    /**
     * Function used to get data from the table.
     * @return the list of data of the table.
     */
    public List<List<Object>> getValues() {
        return getValues(getKeyLists());
    }

    /**
     * Return a string representation of the object.
     */
    public String toString() {
        var sb = new StringBuilder();
        var keys = getKeyLists();

        for (int i=0; i<columns.get(keys.get(0)).size(); i++) {
            for (var key : keys) {
                sb.append(columns.get(key).get(i) + " ");
            }
            sb.append("\n");
        }
        return sb.toString();
    }
}
