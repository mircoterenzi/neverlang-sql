package sql;

import java.util.List;

public class Table {
    private final String name;
    private final List<String> variables;

    public Table(String name, List<String> variables) {
        this.name = name;
        this.variables = variables;
    }

    public String getName() {
        return name;
    }

    public List<String> getVars() {
        return variables;
    }
}
