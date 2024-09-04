bundle sql.SQLAggregateFunConcern {
    slices  sql.GroupBy
            sql.AggregateFunctions
}

module sql.GroupBy {
    imports {
        java.util.List;
        java.util.ArrayList;
        java.util.Map;
        java.util.HashMap;
        neverlang.utils.AttributeList;
        sql.types.SQLType;
        sql.errors.SyntaxError;
    }

    reference syntax {
        provides {
            SelectedData;
        }

        requires {
            SelectedData;
            IdList;
        }

        [GROUP] SelectedData <-- "SELECT" IdList SelectedData "GROUP" "BY" IdList;

        categories:
            Clause = { "SELECT", "GROUP BY" };
    }

    role(evaluation) {
        [GROUP] @{
            Table table = $GROUP[2].table;
            Table result = new Table();
            List<String> columns = AttributeList.collectFrom($GROUP[1],"value");
            List<Aggregate> functions = AttributeList.collectAllFrom($GROUP[1],"function");
            List<String> groupByColumns = AttributeList.collectAllFrom($GROUP[3],"value");

            // Check if the syntax is correct
            List<String> test = new ArrayList<>(columns);
            test.removeAll(groupByColumns);
            if (test.size() != functions.size()) {
                throw new SyntaxError("All columns must be used in an aggregate function");
            }
            // Generate a map containing the columns and their respective aggregate functions
            Map<String, Aggregate> aggregates = new HashMap();
            for (int i = 0; i < test.size(); i++) {
                aggregates.put(test.get(i), functions.get(i));
            }
            // Initialize the result table
            for (String column : columns) {
                if (aggregates.containsKey(column)) {
                    Column newColumn = new Column(column);
                    result.addColumn(newColumn);
                } else {
                    result.addColumn(table.getColumn(column));
                }
            }

            // Group the data
            List<Tuple> data = table.getTuples();
            while (data.size() > 0) {
                // Get all data with the same values for the group by columns
                List<Tuple> group = new ArrayList<>();
                Tuple first = data.get(0);
                group.add(first);
                data.remove(0);
                for (int i = 0; i < data.size(); i++) {
                    Tuple current = data.get(i);
                    if (
                        groupByColumns.stream()
                                .allMatch(column -> first.get(column)
                                .equals(current.get(column)))
                    ) {
                        group.add(current);
                        data.remove(i);
                        i--;
                    }
                }
                // Aggregate the data in a new tuple to be added to the result
                Tuple toAdd = new Tuple();
                for (String column : columns) {
                    if (aggregates.containsKey(column)) {
                        toAdd.put(column, aggregates.get(column).apply(group));
                    } else {
                        toAdd.put(column, group.get(0).get(column));
                    }
                }
                result.addTuple(toAdd);
            }
            $GROUP[0].ref = $GROUP[2].ref;
            $GROUP[0].table = result;
        }.
    }

    role(struct-checking) {
        [GROUP] .{
            $GROUP[0].isTerminal = true;
        }.
    }
}

module sql.AggregateFunctions {
    imports {
        sql.Aggregate;
        sql.Aggregate.AggregateFun;
    }

    reference syntax {
        provides {
            Id;
        }
        requires {
            Id;
        }

        [COUNT] Id <-- "COUNT" "(" Id ")";
        [STAR]  Id <-- "COUNT" "(" "*" ")";
        [SUM]   Id <-- "SUM" "(" Id ")";
        [AVG]   Id <-- "AVG" "(" Id ")";
        [MIN]   Id <-- "MIN" "(" Id ")";
        [MAX]   Id <-- "MAX" "(" Id ")";

        categories:
            AggregateFunction = { "COUNT", "SUM", "AVG", "MIN", "MAX" },
            Operator = { "*" },
            Brackets = { "(", ")" };

    }

    role(evaluation) {
        [COUNT] .{
            eval $COUNT[1];
            $COUNT[0].value = "COUNT(" + $COUNT[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.COUNT, $COUNT[1].value);
            $COUNT[0].function = aggrFun;
        }.
        [STAR] .{
            $STAR[0].value = "COUNT(*)";
            Aggregate aggrFun = new Aggregate(AggregateFun.COUNT_STAR, null);
            $STAR[0].function = aggrFun;
        }.
        [SUM] .{
            eval $SUM[1];
            $SUM[0].value = "SUM(" + $SUM[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.SUM, $SUM[1].value);
            $SUM[0].function = aggrFun;
        }.
        [AVG] .{
            eval $AVG[1];
            $AVG[0].value = "AVG(" + $AVG[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.AVG, $AVG[1].value);
            $AVG[0].function = aggrFun;
        }.
        [MIN] .{
            eval $MIN[1];
            $MIN[0].value = "MIN(" + $MIN[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.MIN, $MIN[1].value);
            $MIN[0].function = aggrFun;
        }.
        [MAX] .{
            eval $MAX[1];
            $MAX[0].value = "MAX(" + $MAX[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.MAX, $MAX[1].value);
            $MAX[0].function = aggrFun;
        }.
    }
}
