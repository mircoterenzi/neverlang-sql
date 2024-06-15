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
            $$DatabaseMap.get($addCol[1].id).add($addCol[2].id, $addCol[2].var);
        }.
        dropCol: .{
            String id = $dropCol[1].id;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException("Unexpected value: \"" + id + "\" is not an existing table");
            }
            $$DatabaseMap.get($dropCol[1].id).remove($dropCol[2].id);
        }.
    }
}