module sql.AlterTable {
    imports {
        java.util.List;
        java.util.stream.Collectors;
    }
    reference syntax {
        addCol:
            Table <-- "ALTER" "TABLE" Table "ADD" Data;     //todo: remove Table and use Id
        dropCol:
            Table <-- "ALTER" "TABLE" Table "DROP" Id;
    }

    role(evaluation) {
        addCol: .{
            Table table = $addCol[1].table;
            List<String> vars = table.getVars();
            vars.add($addCol[2].id);
            $addCol.table = table;
        }.
        dropCol: .{
            Table table = $dropCol[1].table;
            String id = $dropCol[2].id;
            List<String> vars = table.getVars();
            List<String> modifiedVars = vars.stream()
                    .filter(it -> !it.equals(id))
                    .collect(Collectors.toList());
            $dropCol.table = new Table(table.getName(), modifiedVars);
        }.
    }
}