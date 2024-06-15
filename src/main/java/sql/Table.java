package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

public class Table {
    private List<Pair<String, List<Object>>> columns;

    public Table() {
        columns = new ArrayList<>();
    }

    public void add(String name, List<Object> data) {
        columns.add(new Pair<>(name, data));
    }

    public void remove(String name) {
        columns = columns.stream()
                .filter(pair -> !pair.getKey().equals(name))
                .collect(Collectors.toList());
    }

    public List<String> getKeys() {
        return columns.stream()
                .map(pair -> pair.getKey())
                .collect(Collectors.toList());
    }

}
