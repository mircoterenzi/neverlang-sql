package sql;

import java.util.List;
import java.util.ArrayList;
import java.util.function.BiConsumer;
import sql.types.SQLType;

/**
 * Represents a column in a SQL table.
 */
public class Column {
    /**
     * List of constraints for the column.
     */
    private final List<BiConsumer<List<SQLType>, SQLType>> constraints;

    /**
     * Name of the column.
     */
    private final String name;

    /**
     * Constructor for the Column class.
     * @param givenName the name of the column
     */
    public Column(final String givenName) {
        name = givenName;
        constraints = new ArrayList<>();
    }

    /**
     * Constructor for the Column class.
     * @param givenName the name of the column
     * @param constraint the constraint to be added
     */
    public Column(
            final String givenName,
            final BiConsumer<List<SQLType>, SQLType> constraint
    ) {
        this(givenName);
        addConstraint(constraint);
    }

    /**
     * @return the name of the column
     */
    public String getName() {
        return name;
    }

    /**
     * Adds a constraint to the column.
     * @param constraint the constraint to be added
     */
    public void addConstraint(
            final BiConsumer<List<SQLType>, SQLType> constraint
    ) {
        constraints.add(constraint);
    }

    /**
     * Checks the constraints of the column.
     * @param list the list of elements of the table column
     * @param elem the element to be checked
     */
    public void checkConstraints(
            final List<SQLType> list,
            final SQLType elem
    ) {
        constraints.forEach(c -> c.accept(list, elem));
    }
}
