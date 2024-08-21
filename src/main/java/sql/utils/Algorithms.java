package sql.utils;

import java.util.List;

import sql.Table;
import sql.Tuple;

public class Algorithms {

    public final static Integer ASC = 1;
    public final static Integer DESC = -1;
    
    public static Table sortTable(Table table, List<String> columnNames, List<Integer> order) {
        List<Tuple> tuple = table.copy().getTuples();
        String column = columnNames.get(0);
        Table result = table.copy().filterTuple(t -> false);

        while(!tuple.isEmpty()) {
            Table temp = table.copy().filterTuple(t -> false);
            Tuple ref = tuple.get(0);

            for (Tuple current : tuple) {
                if (current.get(column).compareTo(ref.get(column)) == 0) {
                    temp.addTuple(current);
                }
                if ((current.get(column).compareTo(ref.get(column)) < 0 && order.get(0) == ASC) ||
                        (current.get(column).compareTo(ref.get(column)) > 0 && order.get(0) == DESC)) {
                    temp = temp.filterTuple(t -> false);
                    ref = current;
                    temp.addTuple(current);
                }
            }
            if (temp.getTuples().size() > 1 && columnNames.size() > 1) {
                temp = sortTable(temp, columnNames.subList(1, columnNames.size()), order.subList(1, order.size()));
            }
            temp.getTuples().forEach(result::addTuple);
            temp.getTuples().forEach(tuple::remove);
        }
        return result;
    }

}
