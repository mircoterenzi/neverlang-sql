module sql.DropTable {
    reference syntax {
        drop:
            Operation <-- "DROP" "TABLE" Id;
    }

    role(evaluation) {
        drop: .{
            $$DatabaseMap.remove($drop[1].id);
        }.
    }
}