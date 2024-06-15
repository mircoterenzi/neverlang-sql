package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

public class Table {
    private final List<Pair<String, List<Object>>> columns;

    public Table() {
        columns = new ArrayList<>();
    }

    public void add(String name, List<Object> data) {
        this.columns.add(new Pair<>(name, data));
    }

    public List<String> getKeys() {
        return columns.stream()
                .map(pair -> pair.getKey())
                .collect(Collectors.toList());
    }

}
