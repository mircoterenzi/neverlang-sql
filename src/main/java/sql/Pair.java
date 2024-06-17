package sql;

/**
 * Class used to store a pair of objects.
 */
public class Pair<K,V> {
    private K key;
    private V value;

    /**
     * Constructor for the Pair class.
     * @param key
     * @param value
     */
    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }

    /**
     * Getter for the key.
     * @return the key of the pair.
     */
    public K getKey() {
        return key;
    }

    /**
     * Setter for the key.
     * @param key the new key.
     */
    public void setKey(K key) {
        this.key = key;
    }

    /**
     * Getter for the value.
     * @return the value of the pair.
     */
    public V getValue() {
        return value;
    }

    /**
     * Setter for the value.
     * @param value the new value.
     */
    public void setValue(V value) {
        this.value = value;
    }
}
