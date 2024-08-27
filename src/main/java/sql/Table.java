package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.function.Predicate;

import sql.types.SQLType;

/**
 * Represents a table in a SQL database.
 */
public class Table {
    /**
     * The list of tuples in the table.
     */
    private final List<Tuple> tuples;
    /**
     * The list of columns in the table.
     */
    private final List<Column> columns;

    /**
     * Constructor for the Table class.
     */
    public Table() {
        tuples = new ArrayList<>();
        columns = new ArrayList<>();
    }

    /**
     * Checks if a column exists in the table.
     * @param name the name of the column
     * @param message the error message
     */
    private void checkColumnExistence(final String name, final String message) {
        if (columns.stream().map(Column::getName).noneMatch(name::equals)) {
            throw new IllegalArgumentException("[TABLE] " + message);
        }
    }

    /**
     * Adds a column to the table.
     * @param column the column to be added
     */
    public void addColumn(final Column column) {
        String name = column.getName();
        if (columns.stream().map(Column::getName).anyMatch(name::equals)) {
            throw new IllegalArgumentException(
                    "[TABLE] " + name + " already exists"
            );
        }
        columns.add(column);
    }

    /**
     * Removes a column from the table.
     * @param name the name of the column to be removed
     */
    public void removeColumn(final String name) {
        checkColumnExistence(name, name + " does not exist");
        List<Column> columnNames = columns.stream()
                .filter(c -> c.getName().equals(name))
                .toList();
        for (Column column : columnNames) {
            columns.remove(column);
        }
        tuples.forEach(t -> t.remove(name));
    }

    /**
     * Adds a tuple to the table.
     * @param input the tuple to be added
     */
    public void addTuple(final Tuple input) {
        if (input.size() != columns.size()) {
            throw new IllegalArgumentException(
                    "[TABLE] Tuple size does not match column size: found "
                    + input.size() + ", expected " + columns.size()
            );
        }
        for (String column : input.keySet()) {
            List<SQLType> values = tuples.stream()
                    .map(t -> t.get(column))
                    .toList();
            checkColumnExistence(column, column + " does not exist");
            columns.stream()
                    .filter(c -> c.getName().equals(column))
                    .forEach(c ->
                            c.checkConstraints(values, input.get(column))
                    );
        }
        columns.stream().map(Column::getName).forEach(c -> {
            if (!input.containsKey(c)) {
                input.put(c, null);
            }
        });
        tuples.add(input);
    }

    /**
     * Removes a tuple from the table.
     * @param tuple the tuple to be removed
     */
    public void removeTuple(final Tuple tuple) {
        if (!tuples.contains(tuple)) {
            throw new IllegalArgumentException(
                    "[DATA] Tuple " + tuple + " does not exist"
            );
        }
        tuples.remove(tuple);
    }

    /**
     * Filters the table based on a condition.
     * @param condition the condition to filter the table
     * @return the filtered table
     */
    public Table filterTuple(final Predicate<Tuple> condition) {
        Table result = new Table();
        columns.forEach(result::addColumn);
        tuples.stream()
                .filter(condition)
                .map(Tuple::copy)
                .forEach(result::addTuple);
        return result;
    }

    /**
     * Gets the names of the columns in the table.
     * @return the list of column names
     */
    public List<String> getColumnNames() {
        return columns.stream().map(Column::getName).toList();
    }

    /**
     * Gets the columns in the table.
     * @param name the name of the column
     * @return the column
     */
    public Column getColumn(final String name) {
        checkColumnExistence(name, name + " does not exist");
        return columns.stream()
                .filter(c -> c.getName().equals(name))
                .findFirst()
                .orElse(null);
    }

    /**
     * Gets the tuples in the table.
     * @return the list of tuples
     */
    public List<Tuple> getTuples() {
        return new ArrayList<>(tuples);
    }

    /**
     * Copies the table.
     * @return the copy of the table
     */
    public Table copy() {
        Table copy = new Table();
        columns.forEach(copy::addColumn);
        tuples.forEach(t -> copy.addTuple(t.copy()));
        return copy;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (Tuple tuple : tuples) {
            sb.append(tuple).append("\n");
        }
        return sb.toString();
    }
}
