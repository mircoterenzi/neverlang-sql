bundle sql.SQLDataOpConcern {
    slices  sql.PrintData
            sql.TableSelector
            sql.Select
            sql.Where
            sql.OrderBy
            sql.OrderList
            sql.OrderOperator
}

module sql.PrintData {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }

    reference syntax {
        [PRINT]
            Operation <-- SelectedData;
    }

    role(evaluation) {
        [PRINT] .{
            eval $PRINT[1];
            //System.out.println($PRINT[1].table.toString());
            $$DatabaseMap.put("OUTPUT", $PRINT[1].table);
        }.
    }
}

module sql.TableSelector {
    reference syntax {
        [TABLE]
            SelectedData <-- "FROM" Id;
    }

    role(evaluation) {
        [TABLE] .{
            eval $TABLE[1];
            if (!$$DatabaseMap.containsKey($TABLE[1].value)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + $TABLE[1].value + "\" is not an existing table"
                );
            }
            $TABLE[0].table = $$DatabaseMap.get($TABLE[1].value).copy();
            $TABLE[0].ref = $TABLE[1].value;
        }.
    }
}

module sql.Select {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }

    reference syntax {
        [TABLE]
            SelectedData <-- "SELECT" "*" SelectedData;
        [COLUMN_LIST]
            SelectedData <-- "SELECT" IdList SelectedData;
    }

    role(evaluation) {
        [TABLE] .{
            eval $TABLE[1];
            $TABLE[0].table = $TABLE[1].table;
            $TABLE[0].ref = $TABLE[1].ref;
        }.
        [COLUMN_LIST] @{
            Table table = $COLUMN_LIST[2].table;
            Table result = new Table();
            List<String> columns = AttributeList.collectFrom($COLUMN_LIST[1],"value");
            $COLUMN_LIST[0].ref = $COLUMN_LIST[2].ref;

            columns.forEach(c -> result.addColumn(table.getColumn(c)));
            table.getTuples().forEach(t -> {
                Tuple tuple = new Tuple();
                columns.forEach(c -> tuple.put(c, t.get(c)));
                result.addTuple(tuple);
            });
            $COLUMN_LIST[0].table = result;
        }.
    }
    role (output) {
        [TABLE] .{
            System.out.println($TABLE[0].table.toString());
        }.
        [COLUMN_LIST] .{
            System.out.println($COLUMN_LIST[0].table.toString());
        }.
    }
}

module sql.Where {
    imports {
        java.util.function.Predicate;
        sql.Tuple;
    }

    reference syntax {
        provides {
            SelectedData;
        }
        requires {
            SelectedData;
            BoolExpr;
        }

        [WHERE] SelectedData <-- SelectedData "WHERE" BoolExpr;
    }

    role (evaluation) {
        [WHERE] @{
            $WHERE[0].table = ((Table) $WHERE[1].table).copy().filterTuple((Predicate<Tuple>) $WHERE[2].relation);
            $WHERE[0].ref = $WHERE[1].ref;
        }.
    }
}

module sql.OrderBy {
    imports {
        java.util.List;
        neverlang.utils.AttributeList;
        sql.utils.Algorithms;
    }

    reference syntax {
        [ORDER]
            SelectedData <-- SelectedData "ORDER" "BY" OrderList;
    }

    role(evaluation) {
        [ORDER] .{
            eval $ORDER[2];
            List<String> columns = AttributeList.collectFrom($ORDER[2], "value");
            List<Algorithms.Order> order = AttributeList.collectFrom($ORDER[2], "order");
            eval $ORDER[1];
            $ORDER[0].table = $$Algorithms.sortTable($ORDER[1].table, columns, order);
            $ORDER[0].ref = $ORDER[1].ref;
        }.
    }
}

module sql.OrderList {
    reference syntax {
        provides {
            OrderList;
        }
        requires {
            OrderOperator;
        }

        OrderList <-- OrderOperator "," OrderList;
        OrderList <-- OrderOperator;
    }
}

module sql.OrderOperator {
    imports {
        sql.utils.Algorithms;
    }
    
    reference syntax {
        provides {
            OrderOperator;
        }
        requires {
            Id;
        }

        [ASC]       OrderOperator <-- Id "ASC";
        [DESC]      OrderOperator <-- Id "DESC";
        [DEFAULT]   OrderOperator <-- Id;
    }

    role(evaluation) {
        [ASC] .{
            $ASC[0].order = Algorithms.Order.ASC;
            eval $ASC[1];
            $ASC[0].value = $ASC[1].value;
        }.
        [DESC] .{
            $DESC[0].order = Algorithms.Order.DESC;
            eval $DESC[1];
            $DESC[0].value = $DESC[1].value;
        }.
        [DEFAULT] .{
            $DEFAULT[0].order = Algorithms.Order.ASC;
            eval $DEFAULT[1];
            $DEFAULT[0].value = $DEFAULT[1].value;
        }.
    }
}

