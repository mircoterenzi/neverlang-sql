package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.function.Predicate;

import sql.errors.DataInconsistency;
import sql.errors.EntityNotFound;
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
     */
    private void checkColumnExistence(final String name) {
        if (columns.stream().map(Column::getName).noneMatch(name::equals)) {
            throw new EntityNotFound(
                "An attempt to retrieve or use a column that does not exist: "
                + name + ". Make sure it exists and that its name is spelled"
                + "correctly."
            );
        }
    }

    /**
     * Adds a column to the table.
     * @param column the column to be added
     */
    public void addColumn(final Column column) {
        String name = column.getName();
        if (columns.stream().map(Column::getName).anyMatch(name::equals)) {
            throw new DataInconsistency(
                    "Trying to add a column named \"" + name + "\", "
                    + "but a column with this name already exists"
            );
        }
        columns.add(column);
    }

    /**
     * Removes a column from the table.
     * @param column the column to be removed
     */
    public void removeColumn(final Column column) {
        columns.remove(column);
        tuples.forEach(t -> t.remove(column.getName()));
    }

    /**
     * Gets the columns in the table.
     * @return the list of column names
     */
    public List<Column> getColumns() {
        return new ArrayList<>(columns);
    }

    /**
     * Gets a column from the table.
     * @param name the name of the column
     * @return the column with the given name
     */
    public Column getColumn(final String name) {
        checkColumnExistence(name);
        return columns.stream()
                .filter(c -> c.getName().equals(name))
                .findFirst()
                .orElse(null);
    }

    /**
     * Adds a tuple to the table.
     * @param input the tuple to be added
     */
    public void addTuple(final Tuple input) {
        if (input.size() != columns.size()) {
            throw new DataInconsistency(
                "The length of the input tuple does not match the "
                + "table definition: found " + input.size()
                + ", expected " + columns.size()
            );
        }
        for (String column : input.keySet()) {
            List<SQLType> values = tuples.stream()
                    .map(t -> t.get(column))
                    .toList();
            checkColumnExistence(column);
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
            throw new EntityNotFound(
                "The tuple you are trying to delete does not"
                + "exist in the selected table:  " + tuple
            );
        }
        tuples.remove(tuple);
    }

    /**
     * Filters the table based on a condition.
     * @param condition the condition to filter the table
     */
    public void filterTuple(final Predicate<Tuple> condition) {
        List<Tuple> toRemove = tuples.stream()
                .filter(elem -> !condition.test(elem))
                .toList();
        toRemove.forEach(this::removeTuple);
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
