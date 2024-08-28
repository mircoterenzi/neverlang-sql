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
        [PROG] .{
            eval $PROG[1];
            $PROG.db = $$DatabaseMap;
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

        OperationList <-- Operation;
        OperationList <-- OperationList ";" Operation;
    }
}

module sql.EmptyOperation {
    reference syntax {
        provides {
            Operation;
        }
        requires {
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
        requires {
        }

        [ID]    Id <-- /\b[a-zA-Z_][a-zA-Z0-9_]*\b/[id];
    }

    role(evaluation) {
        [ID] .{
            $ID.value = #0.text;
        }.
    }
}
