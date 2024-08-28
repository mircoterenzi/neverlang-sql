bundle sql.SQLTableConcern {
    slices  sql.TableOp
            sql.ColumnList
            sql.ColumnDeclaration
}

module sql.TableOp {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
        java.util.Optional;
    }
    
    reference syntax {
        provides {
            Operation;
        }
        requires {
            Id;
            ColumnList;
        }

        declaration:
            Operation <-- "CREATE" "TABLE" Id "(" ColumnList ")";
        drop:
            Operation <-- "DROP" "TABLE" Id;
        alter_add:
            Operation <-- "ALTER" "TABLE" Id "ADD" Column;
        alter_drop:
            Operation <-- "ALTER" "TABLE" Id "DROP" Id;

        categories:
            TableOp = {"CREATE", "DROP", "ALTER"};
    }

    role(evaluation) {
        declaration: .{
            eval $declaration[1];
            eval $declaration[2];
            List<Column> columns = AttributeList.collectFrom($declaration[2], "column");
            Table table = new Table();
            columns.forEach(column -> table.addColumn(column));
            $$DatabaseMap.put($declaration[1].value, table);
        }.
        drop: .{
            $$DatabaseMap.remove($drop[1]:value);
        }.
        alter_add: @{
            $$DatabaseMap.get($alter_add[1].value).addColumn($alter_add[2].column);
        }.
        alter_drop: @{
            $$DatabaseMap.get($alter_drop[1].value).removeColumn($alter_drop[2].value);
        }.
    }
}

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
        sql.errors.DataInconsistency;
        sql.errors.ConstraintViolation;
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
                if (value != null && !(value instanceof SQLInteger)) {
                    throw new DataInconsistency(
                            "The type of data entered does not match what is defined in the table: " 
                            + "expected SQLInteger, but got " + value.getClass().getSimpleName()
                    );
                }
            };
            $INT_TYPE[0].constraint = constraint;
        }.
        [FLOAT_TYPE] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (value != null && !(value instanceof SQLFloat)) {
                    throw new DataInconsistency(
                            "The type of data entered does not match what is defined in the table: " 
                            + "expected SQLFloat, but got " + value.getClass().getSimpleName()
                    );
                }
            };
            $FLOAT_TYPE[0].constraint = constraint;
        }.
        [VARCHAR_TYPE] .{
            eval $VARCHAR_TYPE[1];
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (value != null) {
                    if (!(value instanceof SQLString)) {
                        throw new DataInconsistency(
                                "The type of data entered does not match what is defined in the table: " 
                                + "expected SQLString, but got " + value.getClass().getSimpleName()
                        );
                    }
                    if (value.toString().length() > ((SQLInteger) $VARCHAR_TYPE[1].value).toDouble()) {
                        throw new ConstraintViolation(
                                "The value is " + value.toString().length() +
                                " characters long, but the column only supports " +
                                ((SQLInteger) $VARCHAR_TYPE[1].value).toDouble()
                        );
                    }
                }
            };
            $VARCHAR_TYPE[0].constraint = constraint;
        }.
        [BOOLEAN_TYPE] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (value != null && !(value instanceof SQLBoolean)) {
                    throw new DataInconsistency(
                            "The type of data entered does not match what is defined in the table: " 
                            + "expected SQLBoolean, but got " + value.getClass().getSimpleName()
                    );
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
        sql.errors.ConstraintViolation;
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
                    throw new ConstraintViolation("Not-null column, but the value is null");
                }
            };
            $NOT_NULL[0].constraint = constraint;
        }.
        [UNIQUE] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (list.contains(value)) {
                    throw new ConstraintViolation("Unique column, but the value " + value + " already exists");
                }
            };
            $UNIQUE[0].constraint = constraint;
        }.
        [KEY] .{
            BiConsumer<List<SQLType>,SQLType> constraint = (list, value) -> {
                if (value == null) {
                    throw new ConstraintViolation("Primary-key column, but the value is null");
                }
                if (list.contains(value)) {
                    throw new ConstraintViolation("Primary-key column, but the value " + value + " already exists");
                }
            };
            $KEY[0].constraint = constraint;
        }.
    }
}

