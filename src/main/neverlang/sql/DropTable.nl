module sql.DropTable {
    reference syntax {
        drop:
            Operation <-- "DROP" "TABLE" Id;
    }

    role(evaluation) {
        drop: .{
            eval $drop[1];
            
            if (!$$DatabaseMap.containsKey($drop[1].id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + $drop[1].id + "\" is not an existing table"
                );
            }

            $$DatabaseMap.remove($drop[1].id);
        }.
    }
}