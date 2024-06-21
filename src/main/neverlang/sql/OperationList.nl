module sql.OperationList {
    reference syntax {
        single:
            OperationList <-- Operation;
        list:
            OperationList <-- OperationList ";" Operation;
            Operation <-- "";
    }

    role(register) {
        single: .{
            $single.db = $$DatabaseMap;
        }.
        list: .{
            $list.db = $$DatabaseMap;
        }.
    }
}