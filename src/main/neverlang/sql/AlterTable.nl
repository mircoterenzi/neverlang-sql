module sql.AlterTable {
    reference syntax {
        alter:
            AlterTable <-- "ALTER" "TABLE" Id;
        add:
            Operation <-- AlterTable "ADD" Data;
        drop:
            Operation <-- AlterTable "DROP" Id;
    }

    role(evaluation) {
        alter: .{
            String id = $alter[1]:id;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + id + "\" is not an existing table"
                );
            }
            $alter.id = id;
        }.
    }

    role(register) {
        add: @{
            $$DatabaseMap.get($add[1].id).addColumn($add[2].id, $add[2].var);
        }.
        drop: @{
            $$DatabaseMap.get($drop[1].id).removeColumn($drop[2].id);
        }.
    }
}