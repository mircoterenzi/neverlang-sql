bundle sql.SQLDataOpConcern {
    slices  sql.DataOperation
            sql.TableSelector
            sql.Select
            sql.Where
            sql.OrderBy
            sql.OrderList
            sql.OrderOperator
}

module sql.DataOperation {
    imports {
        java.util.List;
        neverlang.utils.AttributeList;
        sql.errors.SyntaxError;
    }

    reference syntax {
        provides {
            Operation;
        }
        requires {
            SelectedData;
        }

        [OP]    Operation <-- SelectedData;
    }

    role(struct-checking) {
        [OP] .{
            if (!(Boolean) $OP[1]:isTerminal) {
                throw new SyntaxError("Invalid SQL statement; expected DELETE, INSERT, SELECT or UPDATE");
            }
        }.
    }
}

module sql.TableSelector {
    imports {
        sql.errors.EntityNotFound;
    }

    reference syntax {
        provides {
            SelectedData;
        }
        requires {
            Id;
        }

        [TABLE] SelectedData <-- "FROM" Id;

        categories:
            Clause = { "FROM" };
    }

    role(evaluation) {
        [TABLE] .{
            eval $TABLE[1];
            if (!$$DatabaseMap.containsKey($TABLE[1].value)) {
                throw new EntityNotFound(
                    "Cannot find the table \"" + $TABLE[1].value + "\". "
                    + "Make sure it exists and that its name is spelled correctly."
                );
            }
            $TABLE[0].table = $$DatabaseMap.get($TABLE[1].value).copy();
            $TABLE[0].ref = $TABLE[1].value;
        }.
    }

    role(struct-checking) {
        [TABLE] .{
            $TABLE.isTerminal = false;
        }.
    }
}

module sql.Select {
    imports {
        java.util.List;
        neverlang.utils.AttributeList;
    }

    reference syntax {
        provides {
            SelectedData;
        }
        requires {
            SelectedData;
            IdList;
        }

        [TABLE]
            SelectedData <-- "SELECT" "*" SelectedData;
        [COLUMN_LIST]
            SelectedData <-- "SELECT" IdList SelectedData;
        
        categories:
            Clause = { "SELECT" },
            Operator = { "*" };

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

    role(struct-checking) {
        [TABLE] .{
            $TABLE.isTerminal = true;
        }.
        [COLUMN_LIST] .{
            $COLUMN_LIST.isTerminal = true;
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

        categories:
            Clause = { "WHERE" };
    }

    role (evaluation) {
        [WHERE] @{
            $WHERE[0].table = ((Table) $WHERE[1].table).copy()
                    .filterTuple((Predicate<Tuple>) $WHERE[2].relation);
            $WHERE[0].ref = $WHERE[1].ref;
        }.
    }

    role(struct-checking) {
        [WHERE] .{
            $WHERE.isTerminal = $WHERE[1]:isTerminal;
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
        provides {
            SelectedData;
        }
        requires {
            SelectedData;
            OrderList;
        }

        [ORDER]
            SelectedData <-- SelectedData "ORDER" "BY" OrderList;

        categories:
            Clause = { "ORDER BY" };
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

    role(struct-checking) {
        [ORDER] .{
            $ORDER.isTerminal = $ORDER[1]:isTerminal;
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

        categories:
            OrderOperator = { "ASC", "DESC" };
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
