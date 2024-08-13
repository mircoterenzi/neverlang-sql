package sql;

import java.util.List;

public class Algorithms {
    
    public static Table sortTable(Table table, List<String> columnNames) {
        List<Tuple> tuple = table.copy().getTuples();
        String column = columnNames.get(0);
        Table result = table.copy().select(t -> false);

        while(!tuple.isEmpty()) {
            Table temp = table.copy().select(t -> false);
            Tuple min = tuple.get(0);

            for (Tuple current : tuple) {
                if (((Comparable<Object>) current.get(column)).compareTo(min.get(column)) == 0) { //TODO: unckecked cast, should be fixed
                    temp.insertTuple(current);
                }
                if (((Comparable<Object>) current.get(column)).compareTo(min.get(column)) < 0) {
                    temp = temp.select(t -> false);
                    min = current;
                    temp.insertTuple(current);
                }
            }
            if (temp.getTuples().size() > 1 && columnNames.size() > 1) {
                temp = sortTable(temp, columnNames.subList(1, columnNames.size()));
            }
            temp.getTuples().forEach(result::insertTuple);
            temp.getTuples().forEach(tuple::remove);
        }
        return result;
    }

}
