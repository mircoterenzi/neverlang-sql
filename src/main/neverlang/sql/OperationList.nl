module sql.OperationList {
    reference syntax {
        single:
            OperationList <-- Operation;
        list:
            OperationList <-- OperationList ";" Operation;
    }

    role(evaluation) {
        single: .{
            $single.db = $$DatabaseMap;
        }.
        list: .{
            $list.db = $$DatabaseMap;
        }.
    }
}