bundle sql.SQLCoreConcern {
    slices  sql.Main
            sql.OperationList
            sql.EmptyOperation
            sql.IdList
            sql.ElementId
}

module sql.Main {
    reference syntax {
        provides {
            Program;
        }
        requires {
            OperationList;
        }

        [PROG]  Program <-- OperationList;
    }
    role (evaluation) {
        [PROG] @{
            $PROG.db = $$DatabaseMap;
            $PROG.output = $$DatabaseMap.containsKey("OUTPUT") ? $$DatabaseMap.get("OUTPUT").toString() : ""; //TODO: improve the output testing
        }.
    }
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
