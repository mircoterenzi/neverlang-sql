package sql;

import java.util.function.Function;

public enum Types {
    INT(obj -> obj instanceof Integer),
    FLOAT(obj -> obj instanceof Float),
    VARCHAR(obj -> obj instanceof String),
    BOOLEAN(obj -> obj instanceof Boolean);

    private Function<Object, Boolean> isIstanceOf;

    private Types(Function<Object, Boolean> isIstanceOf) {
        this.isIstanceOf = isIstanceOf;
    }

    public Boolean isIstanceOf(Object elem) {
        return isIstanceOf.apply(elem);
    }
}
