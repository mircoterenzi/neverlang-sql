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
            $single.output = $$DatabaseMap.containsKey("OUTPUT") ? $$DatabaseMap.get("OUTPUT").toString() : "";
        }.
        list: @{
            $list.db = $$DatabaseMap;
            $single.output = $$DatabaseMap.containsKey("OUTPUT") ? $$DatabaseMap.get("OUTPUT").toString() : "";
        }.
    }
}

module sql.ElementIdentifier {
    reference syntax {
        id:
            Id <-- /\b[a-zA-Z_][a-zA-Z0-9_]*\b/;
    }

    role(evaluation) {
        id: .{
            $id.value = #0.text;
        }.
    }
}

module sql.IdList {
    reference syntax {
        IdList <-- Id "," IdList;
        IdList <-- Id;
    }
}