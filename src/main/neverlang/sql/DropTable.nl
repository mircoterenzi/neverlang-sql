module sql.DropTable {
    reference syntax {
        drop:
            Operation <-- "DROP" "TABLE" Id;
    }

    role(evaluation) {
        drop: .{
            String id = $drop[1]:id;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + id + "\" is not an existing table"
                );
            }
            $$DatabaseMap.remove(id);
        }.
    }
}