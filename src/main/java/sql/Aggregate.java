package sql;

import java.util.List;
import java.util.Objects;

import sql.types.SQLType;
import sql.types.SQLFloat;
import sql.types.SQLInteger;

/**
 * Class that represents an aggregate function.
 */
public class Aggregate {

    /**
     * Enum that represents the aggregate functions.
     */
    public enum AggregateFun {
        /**
         * Count aggregate function.
         */
        COUNT,
        /**
         * Sum aggregate function.
         */
        SUM,
        /**
         * Average aggregate function.
         */
        AVG,
        /**
         * Minimum aggregate function.
         */
        MIN,
        /**
         * Maximum aggregate function.
         */
        MAX,
        /**
         * Count star aggregate function.
         */
        COUNT_STAR
    }

    /**
     * ID of the aggregate function.
     */
    private final AggregateFun funID;

    /**
     * Column to which the aggregate function is applied.
     */
    private final String refColumn;

    /**
     * Constructor for the Aggregate class.
     * @param givenFunID the ID of the aggregate function
     * @param givenRefColumn the column to which the aggregate
     *                       function is applied
     */
    public Aggregate(
            final AggregateFun givenFunID,
            final String givenRefColumn
    ) {
        funID = givenFunID;
        refColumn = givenRefColumn;
    }

    /**
     * Applies the aggregate function to a list of tuples.
     * @param tuples the list of tuples
     * @return the result of the aggregate function
     */
    public SQLType apply(final List<Tuple> tuples) {
        return switch (funID) {
            case COUNT -> new SQLInteger(tuples.stream()
                    .map(t -> t.get(refColumn))
                    .filter(Objects::nonNull)
                    .mapToInt(elem -> 1)
                    .sum());
            case SUM -> new SQLFloat(tuples.stream()
                    .map(t -> t.get(refColumn).toDouble())
                    .mapToDouble(elem -> elem)
                    .sum());
            case AVG -> new SQLFloat(tuples.stream()
                    .map(t -> t.get(refColumn).toDouble())
                    .mapToDouble(elem -> elem)
                    .average()
                    .orElse(0));
            case MIN -> new SQLFloat(tuples.stream()
                    .map(t -> t.get(refColumn).toDouble())
                    .mapToDouble(elem -> elem)
                    .min()
                    .orElse(0));
            case MAX -> new SQLFloat(tuples.stream()
                    .map(t -> t.get(refColumn).toDouble())
                    .mapToDouble(elem -> elem)
                    .max()
                    .orElse(0));
            case COUNT_STAR -> new SQLInteger(tuples.stream()
                    .mapToInt(elem -> 1)
                    .sum());
        };
    }
}

