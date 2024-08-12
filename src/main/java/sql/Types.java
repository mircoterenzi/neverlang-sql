package sql;

import java.util.function.Predicate;

/**
 * The Types enum represents the different data types that can be used in SQL.
 * Each type has a corresponding checkType function that can be used to determine if an object belongs to that type.
 */
public enum Types {
    INT(obj -> obj instanceof Integer),
    FLOAT(obj -> obj instanceof Float),
    VARCHAR(obj -> obj instanceof String),
    BOOLEAN(obj -> obj instanceof Boolean);

    /**
     * Function used to check if an object belongs to the type.
     */
    private Predicate<Object> checkType;

    /**
     * Constructor for the Types enum.
     * @param checkType the function used to check if an object belongs to the type.
     */
    private Types(Predicate<Object> checkType) {
        this.checkType = checkType;
    }

    /**
     * Function used to check if an object belongs to the type.
     * @param elem the object to check.
     * @return true if the object belongs to the type, false otherwise.
     */
    public Boolean checkType(Object elem) {
        return checkType.test(elem);
    }
}
