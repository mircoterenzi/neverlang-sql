bundle sql.SQLColumnConcern {
    slices  sql.ColumnDeclaration
            sql.ColumnType
            sql.ColumnConstraints
            sql.ColumnList
}

module sql.ColumnList {
    reference syntax {
        provides {
            ColumnList;
        }
        requires {
            Column;
        }

        ColumnList <-- Column "," ColumnList;
        ColumnList <-- Column;
    }
}

module sql.ColumnDeclaration {
    reference syntax {
        provides {
            Column;
        }
        requires {
            Id;
            ColumnType;
            Constraint;
        }

        [NORMAL]            Column <-- Id ColumnType;
        [WITH_CONSTRAINT]   Column <-- Id ColumnType Constraint;
    }

    role(evaluation) {
        [NORMAL] @{
            $NORMAL[0].value = $NORMAL[1].value;
            $NORMAL[0].type = $NORMAL[2].type;
            $NORMAL[0].isNotNull = false;
            $NORMAL[0].isUnique = false;
        }.
        [WITH_CONSTRAINT] @{
            $WITH_CONSTRAINT[0].value = $WITH_CONSTRAINT[1].value;
            $WITH_CONSTRAINT[0].type = $WITH_CONSTRAINT[2].type;
            $WITH_CONSTRAINT[0].isNotNull = $WITH_CONSTRAINT[3].isNotNull;
            $WITH_CONSTRAINT[0].isUnique = $WITH_CONSTRAINT[3].isUnique;
        }.
    }
}

module sql.ColumnType {
    reference syntax {
        provides {
            ColumnType;
        }
        requires {
            Integer;
        }

        [INT_TYPE]
            ColumnType <-- "INT";
        [FLOAT_TYPE]
            ColumnType <-- "FLOAT";
        [VARCHAR_TYPE]
            ColumnType <-- "VARCHAR" "(" Integer ")";    //TODO: the number of char is fake atm
        [BOOLEAN_TYPE]
            ColumnType <-- "BOOLEAN";

        categories:
            ColumnType = {"INT", "FLOAT", "VARCHAR", "BOOLEAN"};
    }
    
    role(evaluation) {
        [INT_TYPE] .{
            $INT_TYPE[0].type = Types.INT;
        }.
        [FLOAT_TYPE] .{
            $FLOAT_TYPE[0].type = Types.FLOAT;
        }.
        [VARCHAR_TYPE] .{
            $VARCHAR_TYPE[0].type = Types.VARCHAR;
        }.
        [BOOLEAN_TYPE] .{
            $BOOLEAN_TYPE[0].type = Types.BOOLEAN;
        }.
    }
}

module sql.ColumnConstraints {
    reference syntax {
        provides {
            Constraint;
        }

        [NOT_NULL]  Constraint <-- "NOT" "NULL";
        [KEY]       Constraint <-- "PRIMARY" "KEY";
        [UNIQUE]    Constraint <-- "UNIQUE";
    }

    role(evaluation) {
        [NOT_NULL] .{
            $NOT_NULL[0].isNotNull = true;
            $NOT_NULL[0].isUnique = false;
        }.
        [KEY] .{
            $KEY[0].isNotNull = true;
            $KEY[0].isUnique = true;
        }.
        [UNIQUE] .{
            $UNIQUE[0].isNotNull = false;
            $UNIQUE[0].isUnique = true;
        }.
    }
}

