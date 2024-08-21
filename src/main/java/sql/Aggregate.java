package sql;

import java.util.List;
import sql.types.SQLFloat;

public class Aggregate {
    
    public final static Integer COUNT = 0;
    public final static Integer SUM = 1;
    public final static Integer AVG = 2;
    public final static Integer MIN = 3;
    public final static Integer MAX = 4;
    public final static Integer COUNT_STAR = 5;

    private Integer funID;
    private String refColumn;

    public Aggregate(Integer funID, String refColumn) {
        this.funID = funID;
        this.refColumn = refColumn;
    }

    public SQLFloat apply(List<Tuple> tuples) {
        switch(funID) {
            case 0:
                return new SQLFloat(tuples.stream()
                        .map(t -> t.get(refColumn))
                        .filter(elem -> elem != null)
                        .mapToDouble(elem -> 1)
                        .sum());
            case 1:
                return new SQLFloat(tuples.stream()
                        .map(t -> t.get(refColumn).toDouble())
                        .mapToDouble(elem -> elem)
                        .sum());
            case 2:
                return new SQLFloat(tuples.stream()
                        .map(t -> t.get(refColumn).toDouble())
                        .mapToDouble(elem -> elem)
                        .average()
                        .orElse(0));
            case 3:
                return new SQLFloat(tuples.stream()
                        .map(t -> t.get(refColumn).toDouble())
                        .mapToDouble(elem -> elem)
                        .min()
                        .orElse(0));
            case 4:
                return new SQLFloat(tuples.stream()
                        .map(t -> t.get(refColumn).toDouble())
                        .mapToDouble(elem -> elem)
                        .max()
                        .orElse(0));
            case 5:
                return new SQLFloat(tuples.stream()
                        .mapToDouble(elem -> 1)
                        .sum());
            default:
                throw new IllegalArgumentException("Invalid aggregate function");
        }
    }
}

