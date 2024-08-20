package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.function.BiConsumer;
import sql.types.SQLType;

/**
 * Represents a column in a SQL table.
 */
public class Column {

    private final List<BiConsumer<List<SQLType>,SQLType>> constraints;
    private String name;

    public Column(String name) {
        this.name = name;
        constraints = new ArrayList<>();
    }

    public Column(String name, BiConsumer<List<SQLType>,SQLType> constraint) {
        this(name);
        addConstraint(constraint);
    }

    public String getName() {
        return name;
    }

    public void addConstraint(BiConsumer<List<SQLType>,SQLType> constraint) {
        constraints.add(constraint);
    }

    public void checkConstraints(List<SQLType> list, SQLType elem) {
        constraints.forEach(c -> c.accept(list, elem));
    }
}
