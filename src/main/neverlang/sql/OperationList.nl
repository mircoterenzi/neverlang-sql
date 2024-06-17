module sql.OperationList {
    reference syntax {
        single:
            OperationList <-- Operation;
        comma:
            OperationList <-- OperationList ";";
        list:
            OperationList <-- OperationList ";" Operation;
    }

    role(evaluation) {
        single: .{
            $single.db = $$DatabaseMap;
        }.
        comma: .{
            $comma.db = $$DatabaseMap;
        }.
        list: .{
            $list.db = $$DatabaseMap;
        }.
    }
}