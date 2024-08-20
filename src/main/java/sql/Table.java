package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.stream.Collectors;
import java.util.function.Predicate;

/**
 * Represents a table in a SQL database.
 */
public class Table {
    private List<Tuple> tuples;
    private LinkedHashMap<String, Column> columns;

    public Table() {
        tuples = new ArrayList<>();
        columns = new LinkedHashMap<>();
    }

    public void addColumn(String name, Column column) {
        if (columns.containsKey(name)) {
            throw new IllegalArgumentException("[TABLE] Column " + name + " already exists");
        }
        columns.put(name, column);
        
    }

    public void removeColumn(String name) {
        if (!columns.containsKey(name)) {
            throw new IllegalArgumentException("[TABLE] Column does not exist");
        }
        columns.remove(name);
        for (Tuple tuple : tuples) {
            tuple.remove(name);
        }
    }

    public void addTuple(Tuple tuple) {
        if (tuple.size() != columns.size()) {
            throw new IllegalArgumentException("[DATA] Tuple size does not match column size: found " +
                    tuple.size() + ", expected " + columns.size());
        }
        for (String key : tuple.keySet()) {
            if (!columns.containsKey(key)) {
                throw new IllegalArgumentException("[DATA] Column " + key + " does not exist");
            }
            /* TODO: Uncomment this block
            if (columns.get(key).getType().checkType(tuple.get(key))) {
                throw new IllegalArgumentException("[DATA] Data type mismatch: found " +
                        tuple.get(key).getClass().getSimpleName() + ", expected " +
                        columns.get(key).getType());
            }
            */
            if (columns.get(key).isNotNull() && tuple.get(key) == null) {
                throw new IllegalArgumentException("[DATA] Column " + key + "does not allow null values");
            }
            if (columns.get(key).isUnique() && tuples.stream().anyMatch(t -> t.get(key).equals(tuple.get(key)))) {
                throw new IllegalArgumentException("[DATA] Column " + key + " values must be unique");
            }
        }
        for (String key : columns.keySet()) {
            if (!tuple.keySet().contains(key)) {
                tuple.put(key, null);
            }
        }
        tuples.add(tuple);
    }

    public void removeTuple(Tuple tuple) {
        if (!tuples.contains(tuple)) {
            throw new IllegalArgumentException("[DATA] Tuple " + tuple + " does not exist");
        }
        tuples.remove(tuple);
    }

    public Table filterTuple(Predicate<Tuple> condition) {
        Table result = new Table();
        for (String key : columns.keySet()) {
            result.addColumn(key, columns.get(key));
        }
        for (Tuple tuple : tuples) {
            if (condition.test(tuple)) {
                result.addTuple(tuple.copy());
            }
        }
        return result;
    }

    public List<String> getColumnNames() {
        return columns.keySet().stream().collect(Collectors.toList());
    }

    public List<Tuple> getTuples() {
        return tuples;
    }

    public Table copy() {
        Table copy = new Table();
        for (String key : columns.keySet()) {
            copy.addColumn(key, columns.get(key));
        }
        for (Tuple tuple : tuples) {
            copy.addTuple(tuple.copy());
        }
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
