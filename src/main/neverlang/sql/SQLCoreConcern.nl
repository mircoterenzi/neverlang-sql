bundle sql.SQLCoreConcern {
    slices  sql.OperationList
            sql.ElementIdentifier
            sql.IdList
}

module sql.OperationList {
    reference syntax {
        single:
            OperationList <-- Operation;
        list:
            OperationList <-- OperationList ";" Operation;
        empty:
            Operation <-- "";
    }

    role(register) {
        single: @{
            $single.db = $$DatabaseMap;
        }.
        list: @{
            $list.db = $$DatabaseMap;
        }.
    }
}

module sql.ElementIdentifier {
    reference syntax {
        id:
            Id <-- String;
    }

    role(evaluation) {
        id: .{
            $id.id = $id[1].val;
        }.
    }
}

module sql.IdList {
    reference syntax {
        IdList <-- Id "," IdList;
        IdList <-- Id;
    }
}