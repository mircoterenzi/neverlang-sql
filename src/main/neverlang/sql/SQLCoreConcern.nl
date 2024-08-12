bundle sql.SQLCoreConcern {
    slices  sql.OperationList
            sql.EmptyOperation
            sql.IdList
            sql.ElementId
}

module sql.OperationList {
    reference syntax {
        provides {
            OperationList;
        }
        requires {
            Operation;
        }

        single:
            OperationList <-- Operation;
        list:
            OperationList <-- OperationList ";" Operation;
    }

    role(register) {
        single: @{
            $single.db = $$DatabaseMap;
            $single.output = $$DatabaseMap.containsKey("OUTPUT") ? $$DatabaseMap.get("OUTPUT").toString() : ""; //TODO: improve the output check
        }.
        list: @{
            $list.db = $$DatabaseMap;
            $single.output = $$DatabaseMap.containsKey("OUTPUT") ? $$DatabaseMap.get("OUTPUT").toString() : "";
        }.
    }
}

module sql.EmptyOperation {
    reference syntax {
        provides {
            Operation;
        }

        Operation <-- "";
    }
}

module sql.IdList {
    reference syntax {
        provides {
            IdList;
        }
        requires {
            Id;
        }

        IdList <-- Id "," IdList;
        IdList <-- Id;
    }
}

module sql.ElementId {
    reference syntax {
        provides {
            Id;
        }

        id:
            Id <-- /\b[a-zA-Z_][a-zA-Z0-9_]*\b/[id];
    }

    role(evaluation) {
        id: .{
            $id.value = #0.text;
        }.
    }
}
