package sql;

import java.util.List;
import java.util.Set;
import java.util.HashMap;

public class Table {
    private final HashMap<String, List<Object>> columns;

    public Table() {
        columns = new HashMap<>();
    }

    public void add(String name, List<Object> data) {
        this.columns.put(name, data);
    }

    public Set<String> getKeys() {
        return columns.keySet();
    }

}
