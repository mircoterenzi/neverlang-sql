package sql.utils;

import java.util.List;

import sql.Table;
import sql.Tuple;

/**
 * Class that contains the algorithms used by SQL semantics.
 */
public class Algorithms {
    /**
     * Constant that represents the ASC order.
     */
    public static final Integer ASC = 1;

    /**
     * Constant that represents the DESC order.
     */
    public static final Integer DESC = -1;

    /**
     * Method that sorts a table based on the given column names and order.
     * @param table the table to be sorted
     * @param columnNames the list of column names to be sorted by
     * @param order the list of orders for each column
     * @return the sorted table
     */
    public static Table sortTable(
        final Table table,
        final List<String> columnNames,
        final List<Integer> order
    ) {
        List<Tuple> tuple = table.copy().getTuples();
        String column = columnNames.get(0);
        Table result = table.copy().filterTuple(t -> false);

        while (!tuple.isEmpty()) {
            Table temp = table.copy().filterTuple(t -> false);
            Tuple ref = tuple.get(0);

            for (Tuple current : tuple) {
                if (current.get(column).compareTo(ref.get(column)) == 0) {
                    temp.addTuple(current);
                }
                if ((current.get(column).compareTo(ref.get(column)) < 0
                        && order.get(0).equals(ASC))
                    || (current.get(column).compareTo(ref.get(column)) > 0
                        && order.get(0).equals(DESC))) {
                    temp = temp.filterTuple(t -> false);
                    ref = current;
                    temp.addTuple(current);
                }
            }
            if (temp.getTuples().size() > 1 && columnNames.size() > 1) {
                temp = sortTable(
                        temp,
                        columnNames.subList(
                                1,
                                columnNames.size()
                        ),
                        order.subList(1, order.size())
                );
            }
            temp.getTuples().forEach(result::addTuple);
            temp.getTuples().forEach(tuple::remove);
        }
        return result;
    }

}
