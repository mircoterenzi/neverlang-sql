package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.function.Predicate;

import sql.types.SQLType;

/**
 * Represents a table in a SQL database.
 */
public class Table {
    private final List<Tuple> tuples;
    private final List<Column> columns;

    public Table() {
        tuples = new ArrayList<>();
        columns = new ArrayList<>();
    }

    private void checkColumnExistence(String name, String message) {
        if (!columns.stream().map(Column::getName).anyMatch(name::equals)) {
            throw new IllegalArgumentException("[TABLE] " + message);
        }
    }

    public void addColumn(Column column) {
        String name = column.getName();
        if (columns.stream().map(Column::getName).anyMatch(name::equals)) {
            throw new IllegalArgumentException("[TABLE] " + name + " already exists");
        }
        columns.add(column);
    }

    public void removeColumn(String name) {
        checkColumnExistence(name, name + " does not exist");
        for (Column column : columns.stream().filter(c -> c.getName().equals(name)).toList()) {
            columns.remove(column);
        }
        tuples.stream().forEach(t -> t.remove(name));
    }

    public void addTuple(Tuple input) {
        if (input.size() != columns.size()) {
            throw new IllegalArgumentException(
                "[TABLE] Tuple size does not match column size: found " +
                input.size() + ", expected " + columns.size()
            );
        }
        for (String column : input.keySet()) {
            List<SQLType> values = tuples.stream().map(t -> t.get(column)).toList();
            checkColumnExistence(column, column + " does not exist");
            columns.stream()
                    .filter(c -> c.getName().equals(column))
                    .forEach(c -> c.checkConstraints(values, input.get(column)));
        }
        columns.stream().map(Column::getName).forEach(c -> {
            if (!input.keySet().contains(c)) {
                input.put(c, null);
            }
        });
        tuples.add(input);
    }

    public void removeTuple(Tuple tuple) {
        if (!tuples.contains(tuple)) {
            throw new IllegalArgumentException("[DATA] Tuple " + tuple + " does not exist");
        }
        tuples.remove(tuple);
    }

    public Table filterTuple(Predicate<Tuple> condition) {
        Table result = new Table();
        columns.stream().forEach(c -> result.addColumn(c));
        tuples.stream().filter(condition).map(Tuple::copy).forEach(result::addTuple);
        return result;
    }

    public List<String> getColumnNames() {
        return columns.stream().map(Column::getName).toList();
    }

    public List<Tuple> getTuples() {
        return tuples;
    }

    public Table copy() {
        Table copy = new Table();
        columns.stream().forEach(c -> copy.addColumn(c));
        tuples.stream().forEach(t -> copy.addTuple(t.copy()));
        return copy;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (Tuple tuple : tuples) {
            sb.append(tuple + "\n");
        }
        return sb.toString();
    }
}
