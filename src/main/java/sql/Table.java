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
            throw new IllegalArgumentException("[TABLE] Column already exists");
        }
        columns.put(name, column);
    }

    public void removeColumn(String name) {
        if (!columns.containsKey(name)) {
            throw new IllegalArgumentException("[TABLE] Column does not exist");
        }
        columns.remove(name);
    }

    public void insertTuple(Tuple tuple) {
        if (tuple.size() != columns.size()) {
            throw new IllegalArgumentException("[DATA] Tuple size does not match column size: found " +
                    tuple.size() + ", expected " + columns.size());
        }
        for (String key : tuple.keySet()) {
            if (!columns.containsKey(key)) {
                throw new IllegalArgumentException("[DATA] Column " + key + " does not exist");
            }
            /*
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

    public void deleteTuple(Tuple tuple) {
        if (!tuples.contains(tuple)) {
            throw new IllegalArgumentException("[DATA] Tuple " + tuple + " does not exist");
        }
        tuples.remove(tuple);
    }

    public List<Tuple> select(Predicate<Tuple> condition) {
        return tuples.stream()
                .filter(elem -> condition.test(elem))
                .collect(Collectors.toList());
    }

    public List<Tuple> selectAll() {
        return tuples;
    }

    public List<String> getColumnNames() {
        return columns.keySet().stream().collect(Collectors.toList());
    }

    public void print() {
        for (String key : columns.keySet()) {
            System.out.print(key + "\t");
        }
        System.out.println();
        for (Tuple tuple : tuples) {
            for (String key : columns.keySet()) {
                System.out.print(tuple.get(key) + "\t");
            }
            System.out.println();
        }
    }
}
