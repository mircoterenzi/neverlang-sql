package sql;

import java.util.List;

public class Algorithms {
    
    public static Table sortTable(Table table, List<String> columnNames) {
        List<Tuple> tuple = table.copy().getTuples();
        String column = columnNames.get(0);
        Table result = table.copy().filterTuple(t -> false);

        while(!tuple.isEmpty()) {
            Table temp = table.copy().filterTuple(t -> false);
            Tuple min = tuple.get(0);

            for (Tuple current : tuple) {
                if (current.get(column).compareTo(min.get(column)) == 0) {
                    temp.addTuple(current);
                }
                if (current.get(column).compareTo(min.get(column)) < 0) {
                    temp = temp.filterTuple(t -> false);
                    min = current;
                    temp.addTuple(current);
                }
            }
            if (temp.getTuples().size() > 1 && columnNames.size() > 1) {
                temp = sortTable(temp, columnNames.subList(1, columnNames.size()));
            }
            temp.getTuples().forEach(result::addTuple);
            temp.getTuples().forEach(tuple::remove);
        }
        return result;
    }

}
