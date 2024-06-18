module sql.Program {
    reference syntax {
        program:
            Program <-- OperationList;
    }

    role(evaluation) {
        program: .{
            $program.db = $$DatabaseMap;
        }.
    }
}