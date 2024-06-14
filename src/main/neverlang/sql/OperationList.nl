module sql.OperationList {
    reference syntax {
        single:
            OperationList <-- Operation;
        list:
            OperationList <-- OperationList ";" Operation;
    }

    role(evaluation) {
        single: .{
            $single.db = $single[1].db;
        }.
        list: .{
            $list.db = $list[1].db;
        }.
    }
}