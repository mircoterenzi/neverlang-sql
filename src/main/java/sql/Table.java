package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

/**
 * Class used to store a table of data.
 */
public class Table {
    private List<Pair<String, List<Object>>> columns;

    /**
     * Constructor for the Table class.
     */
    public Table() {
        columns = new ArrayList<>();
    }

    /**
     * Function used to add a column to the table.
     * @param name the name of the column.
     * @param data the data of the column.
     */
    public void add(String name, List<Object> data) {
        columns.add(new Pair<>(name, data));
    }

    /**
     * Function used to remove a column from the table.
     * @param name the name of the column.
     */
    public void remove(String name) {
        columns = columns.stream()
                .filter(pair -> !pair.getKey().equals(name))
                .collect(Collectors.toList());
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
            var item = columns.stream()
                    .filter(pair -> pair.getKey().equals(heading))
                    .findAny();
            if (item.isPresent()) {
                var column = columns.get(columns.indexOf(item.get()));
                List<Object> list = column.getValue();
                System.out.println(values.get(i) + ": " + values.get(i).getClass());    //TODO: check for variable type
                list.add(values.get(i));
                column.setValue(list);
                columns.set(columns.indexOf(column), column);
            } else {
                throw new IllegalArgumentException(
                    "Column \"" + heading + "\" does not exist"
                );
            }
        }
        // If there are columns that are not in the list, add null values.
        for (var column : columns) {
            if (!headings.contains(column.getKey())) {
                headings.add(null);
            }
        }
    }

    /**
     * Function used to add data to the table.
     * @param values list of data to be added to the table.
     */
    public void addValues(List<Object> values) {
        addValues(getKeys(), values);
    }

    /**
     * Function used to get the column names.
     * @return the list of column names.
     */
    public List<String> getKeys() {
        return columns.stream()
                .map(pair -> pair.getKey())
                .collect(Collectors.toList());
    }

    /**
     * Function used to get data from a list of columns.
     * @param keys the list of column names.
     * @return the list of data of the columns.
     */
    public List<List<Object>> getValues(List<String> keys) {
        return columns.stream()
                .filter(pair -> keys.contains(pair.getKey()))
                .map(pair -> pair.getValue())
                .collect(Collectors.toList());
    }

    /**
     * Function used to get data from the table.
     * @return the list of data of the table.
     */
    public List<List<Object>> getValues() {
        return getValues(getKeys());
    }

    /**
     * Return a string representation of the object.
     */
    public String toString() {
        var sb = new StringBuilder();
        for (int i=0; i<columns.get(0).getValue().size(); i++) {
            for (var key : getKeys()) {
                var item = columns.stream()
                        .filter(pair -> pair.getKey().equals(key))
                        .findAny();
                if (item.isPresent()) {
                    sb.append(item.get().getValue().get(i));
                    sb.append(" ");
                }
            }
            sb.append("\n");
        }
        return sb.toString();
    }
}
