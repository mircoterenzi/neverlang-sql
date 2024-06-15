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

    public void addValues(List<String> headings, List<Object> values) {
        if (headings.size() != values.size()) {
            throw new IllegalArgumentException();
        }
        for (int i=0; i<values.size(); i++) {
            var heading = headings.get(i);
            var item = columns.stream()
                    .filter(pair -> pair.getKey().equals(heading))
                    .findAny();
            if (item.isPresent()) {
                var column = columns.get(columns.indexOf(item.get()));
                List<Object> list = column.getValue();
                list.add(values.get(i));
                column.setValue(list);
                columns.set(columns.indexOf(column), column);
            } else {
                throw new IllegalArgumentException();
            }

        }
    }

    public void addValues(List<Object> values) {
        addValues(getKeys(), values);
    }

    public List<String> getKeys() {
        return columns.stream()
                .map(pair -> pair.getKey())
                .collect(Collectors.toList());
    }

}
