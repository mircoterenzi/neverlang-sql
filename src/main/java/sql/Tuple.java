package sql;

import java.util.LinkedHashMap;

/**
 * Represents a tuple in a SQL database.
 */
public class Tuple extends LinkedHashMap<String,Object> {

    public Tuple copy() {
        Tuple copy = new Tuple();
        for (String key : keySet()) {
            copy.put(key, get(key));
        }
        return copy;
    }
    
}
