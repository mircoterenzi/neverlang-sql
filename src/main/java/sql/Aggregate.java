package sql;

import java.util.List;
import sql.types.SQLFloat;
import sql.types.SQLType;

public class Aggregate {
    
    public final static Integer COUNT = 0;
    public final static Integer SUM = 1;
    public final static Integer AVG = 2;
    public final static Integer MIN = 3;
    public final static Integer MAX = 4;

    private Integer funID;
    private String refColumn;

    public Aggregate(Integer funID, String refColumn) {
        this.funID = funID;
        this.refColumn = refColumn;
    }

    public SQLFloat apply(List<Tuple> tuples) {
        List<SQLType> list = tuples.stream().map(t -> t.get(refColumn)).toList();
        switch(funID) {
            case 0:
                return new SQLFloat(list.stream().filter(elem -> elem != null).mapToDouble(elem -> 1).sum());
            case 1:
                return new SQLFloat(list.stream().map(elem -> elem.toDouble()).mapToDouble(elem -> elem).sum());
            case 2:
                return new SQLFloat(list.stream().map(elem -> elem.toDouble()).mapToDouble(elem -> elem).average().orElse(0));
            case 3:
                return new SQLFloat(list.stream().map(elem -> elem.toDouble()).mapToDouble(elem -> elem).min().orElse(0));
            case 4:
                return new SQLFloat(list.stream().map(elem -> elem.toDouble()).mapToDouble(elem -> elem).max().orElse(0));
            default:
                throw new IllegalArgumentException("Invalid aggregate function");
        }
    }
}
