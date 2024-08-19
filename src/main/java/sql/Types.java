package sql;

import java.util.function.Predicate;
import sql.types.*;

/**
 * The Types enum represents the different data types that can be used in SQL.
 * Each type has a corresponding checkType function that can be used to determine if an object belongs to that type.
 */
public enum Types {
    INT(obj -> obj instanceof SQLInteger),
    FLOAT(obj -> obj instanceof SQLFloat),
    VARCHAR(obj -> obj instanceof SQLString),
    BOOLEAN(obj -> obj instanceof SQLBoolean);

    /**
     * Function used to check if an object belongs to the type.
     */
    private Predicate<SQLType> checkType;

    /**
     * Constructor for the Types enum.
     * @param checkType the function used to check if an object belongs to the type.
     */
    private Types(Predicate<SQLType> checkType) {
        this.checkType = checkType;
    }

    /**
     * Function used to check if an object belongs to the type.
     * @param elem the object to check.
     * @return true if the object belongs to the type, false otherwise.
     */
    public Boolean checkType(SQLType elem) {
        return checkType.test(elem);
    }
}
