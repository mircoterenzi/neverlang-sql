package sql;

import java.util.function.Function;

public enum Types {
    INT(str -> Integer.parseInt(str)),
    FLOAT(str -> Float.parseFloat(str)),
    VARCHAR(str -> str),
    BOOLEAN(str -> {
        if (str.equals("True")) {
            return Boolean.TRUE;
        } else if (str.equals("False")) {
            return Boolean.FALSE;
        } else {
            throw new IllegalArgumentException("Error during the boolean evaluation");
        }
    });

    private Function<String,Object> convertFun;

    private Types(Function<String,Object> convertFun) {
        this.convertFun = convertFun;
    }

    public Object convert(String id) {
        return convertFun.apply(id);
    }
}