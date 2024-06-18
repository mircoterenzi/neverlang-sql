module sql.AlterTable {
    reference syntax {
        add:
            Operation <-- "ALTER" "TABLE" Id "ADD" Data;
        drop:
            Operation <-- "ALTER" "TABLE" Id "DROP" Id;
    }

    role(evaluation) {
        add: .{
            eval $add[1];
            eval $add[2];

            if (!$$DatabaseMap.containsKey($add[1].id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + $add[1].id + "\" is not an existing table"
                );
            }

            $$DatabaseMap.get($add[1].id).add($add[2].id, $add[2].var);
        }.
        drop: .{
            eval $drop[1];
            eval $drop[2];

            if (!$$DatabaseMap.containsKey($drop[1].id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + $drop[1].id + "\" is not an existing table"
                );
            }

            $$DatabaseMap.get($drop[1].id).remove($drop[2].id);
        }.
    }
}