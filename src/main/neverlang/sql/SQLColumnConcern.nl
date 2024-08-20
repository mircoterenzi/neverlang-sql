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
    imports {
        sql.Column;
    }

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
            $NORMAL[0].column = new Column($NORMAL[1].value, $NORMAL[2].constraint);
        }.
        [WITH_CONSTRAINT] @{
            Column column = new Column($WITH_CONSTRAINT[1].value, $WITH_CONSTRAINT[2].constraint);
            column.addConstraint($WITH_CONSTRAINT[3].constraint);
            $WITH_CONSTRAINT[0].column = column;
        }.
    }
}

module sql.ColumnType {
    imports {
        java.util.function.BiConsumer;
        java.util.List;
        sql.types.*;
    }

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
            ColumnType <-- "VARCHAR" "(" Integer ")";
        [BOOLEAN_TYPE]
            ColumnType <-- "BOOLEAN";

        categories:
            ColumnType = {"INT", "FLOAT", "VARCHAR", "BOOLEAN"};
    }
    
    role(evaluation) {
        [INT_TYPE] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (!(value instanceof SQLInteger)) {
                    throw new RuntimeException("Integer column, but the value is " + value.getClass().getSimpleName());
                }
            };
            $INT_TYPE[0].constraint = constraint;
        }.
        [FLOAT_TYPE] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (!(value instanceof SQLFloat)) {
                    throw new RuntimeException("Float column, but the value is " + value.getClass().getSimpleName());
                }
            };
            $FLOAT_TYPE[0].constraint = constraint;
        }.
        [VARCHAR_TYPE] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (!(value instanceof SQLString)) {
                    throw new RuntimeException("Varchar column, but the value is " + value.getClass().getSimpleName());
                }
                if (value.toString().length() > ((SQLInteger) $VARCHAR_TYPE[1].value).toDouble()) {
                    throw new RuntimeException("The value is " + value.toString().length() +
                            " characters long, but the column only supports " +
                            ((SQLInteger) $VARCHAR_TYPE[1].value).toDouble());
                }
            };
            $VARCHAR_TYPE[0].constraint = constraint;
        }.
        [BOOLEAN_TYPE] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (!(value instanceof SQLBoolean)) {
                    throw new RuntimeException("Boolean column, but the value is " + value.getClass().getSimpleName());
                }
            };
            $BOOLEAN_TYPE[0].constraint = constraint;
        }.
    }
}

module sql.ColumnConstraints {
    imports {
        java.util.function.BiConsumer;
        java.util.List;
        sql.types.SQLType;
    }

    reference syntax {
        provides {
            Constraint;
        }

        [NOT_NULL]  Constraint <-- "NOT" "NULL";
        [UNIQUE]    Constraint <-- "UNIQUE";
        [KEY]       Constraint <-- "PRIMARY" "KEY";

        categories:
            Constraint = {"NOT_NULL", "UNIQUE", "KEY"};
    }

    role(evaluation) {
        [NOT_NULL] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (value == null) {
                    throw new RuntimeException("Not-null column, but the value is null");
                }
            };
            $NOT_NULL[0].constraint = constraint;
        }.
        [UNIQUE] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (list.contains(value)) {
                    throw new RuntimeException("Unique column, but the value " + value + " already exists");
                }
            };
            $UNIQUE[0].constraint = constraint;
        }.
        [KEY] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (value == null) {
                    throw new RuntimeException("Primary-key column, but the value is null");
                }
                if (list.contains(value)) {
                    throw new RuntimeException("Primary-key column, but the value " + value + " already exists");
                }
            };
            $KEY[0].constraint = constraint;
        }.
    }
}

