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
        for (String key : keySet()) {
            copy.put(key, get(key));
        }
        return copy;
    }
}
