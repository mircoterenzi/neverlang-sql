package sql;

import java.util.LinkedHashMap;

import sql.types.SQLType;

/**
 * Represents a tuple in a SQL database.
 */
public class Tuple extends LinkedHashMap<String, SQLType> {

    /**
     * @return a copy of the tuple
     */
    public Tuple copy() {
        Tuple copy = new Tuple();
        copy.putAll(this);
        return copy;
    }
}
