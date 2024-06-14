module sql.AlterTable {
    imports {
        java.util.List;
        java.util.stream.Collectors;
    }
    reference syntax {
        addCol:
            Operation <-- "ALTER" "TABLE" Id "ADD" Data;
        dropCol:
            Operation <-- "ALTER" "TABLE" Id "DROP" Id;
    }

    role(evaluation) {
        addCol: .{
            $$DatabaseMap.get($addCol[1].id).add($addCol[2].id);
            $addCol.db = $$DatabaseMap;
        }.
        dropCol: .{
            String id = $dropCol[1].id;
            List<String> vars = $$DatabaseMap.get(id);
            List<String> modifiedVars = vars.stream()
                    .filter(it -> !it.equals($dropCol[2].id))
                    .collect(Collectors.toList());
            $$DatabaseMap.put(id, modifiedVars);
            $dropCol.db = $$DatabaseMap;
        }.
    }
}