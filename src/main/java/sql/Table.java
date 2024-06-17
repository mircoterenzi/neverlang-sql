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

    public List<List<Object>> getValues(List<String> keys) {
        return columns.stream()
                .filter(pair -> keys.contains(pair.getKey()))
                .map(pair -> pair.getValue())
                .collect(Collectors.toList());
    }

    public List<List<Object>> getValues() {
        return getValues(getKeys());
    }

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
