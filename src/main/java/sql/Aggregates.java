package sql;

import java.util.function.Function;
import java.util.List;
import sql.types.SQLFloat;
import sql.types.SQLType;

public enum Aggregates {
    COUNT(list -> {
        return (double) list.stream().filter(elem -> elem != null).mapToInt(elem -> 1).sum();
    }),
    SUM(list -> {
        return list.stream().map(elem -> elem.toDouble()).mapToDouble(elem -> elem).sum();
    }),
    AVG(list -> {
        return list.stream().map(elem -> elem.toDouble()).mapToDouble(elem -> elem).average().orElse(0);
    }),
    MIN(list -> {
        return list.stream().map(elem -> elem.toDouble()).mapToDouble(elem -> elem).min().orElse(0);
    }),
    MAX(list -> {
        return list.stream().map(elem -> elem.toDouble()).mapToDouble(elem -> elem).max().orElse(0);
    });

    private Function<List<SQLType>,Double> task;

    private Aggregates(Function<List<SQLType>,Double> task) {
        this.task = task;
    }

    public SQLFloat apply(List<SQLType> elem) {
        return new SQLFloat(Float.parseFloat(task.apply(elem).toString()));
    }
}
