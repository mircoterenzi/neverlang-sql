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
            if (!$$DatabaseMap.containsKey($addCol[1].id)) {
                throw new IllegalArgumentException("Unexpected value: \"" + $addCol[1].id + "\" is not an existing table");
            }
            $$DatabaseMap.get($addCol[1].id).add($addCol[2].id);
        }.
        dropCol: .{
            String id = $dropCol[1].id;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException("Unexpected value: \"" + id + "\" is not an existing table");
            }

            List<String> vars = $$DatabaseMap.get(id);
            List<String> modifiedVars = vars.stream()
                    .filter(it -> !it.equals($dropCol[2].id))
                    .collect(Collectors.toList());
            $$DatabaseMap.put(id, modifiedVars);
        }.
    }
}