bundle sql.SQLAggregateFunConcern {
    slices  sql.GroupBy
            sql.AggregateList
            sql.AggregateFunctions
}

module sql.GroupBy {
    imports {
        java.util.List;
        java.util.ArrayList;
        java.util.Optional;
        neverlang.utils.AttributeList;
        sql.types.SQLType;
    }
    reference syntax {
        provides {
            SelectedData;
        }

        requires {
            SelectedData;
            IdList;
            AggregateList;
        }

        [GROUP]     SelectedData <-- "SELECT" AggregateList SelectedData "GROUP" "BY" IdList;
    }

    role(evaluation) {
        [GROUP] .{
            eval $GROUP[1];

            Table table = $GROUP[2].table;
            Table result = new Table();
            List<Tuple> data = table.getTuples();
            List<String> columns = AttributeList.collectFrom($GROUP[1],"value");
            List<Optional<Aggregate>> functions = AttributeList.collectFrom($GROUP[1],"function");
            List<String> groupByColumns = AttributeList.collectFrom($GROUP[3],"value");
            $GROUP[0].ref = $GROUP[2].ref;

            columns.stream()
                    .filter(c -> groupByColumns.contains(c))
                    .forEach(c -> result.addColumn(table.getColumn(c)));

            // Checks if all the columns are used in an aggregate function
            for (int i = 0; i < columns.size(); i++) {
                if (!groupByColumns.contains(columns.get(i))) {
                    if (!functions.get(i).isPresent()) {
                        throw new RuntimeException("Column " + columns.get(i) + " must be used in an aggregate function");
                    } else {
                        Column col = new Column(columns.get(i));
                        result.addColumn(col);
                    }
                }
            }

            // Group the data
            while (data.size() > 0) {
                // Get all data with the same value on group-by columns
                List<Tuple> temp = new ArrayList<>();
                temp.add(data.get(0));
                data.remove(0);
                for (int i = 0; i < data.size(); i++) {
                    Tuple current = data.get(i);
                    Tuple reference = temp.get(0);
                    if (groupByColumns.stream().allMatch(c -> current.get(c).equals(reference.get(c)))) {
                        temp.add(current);
                        data.remove(i);
                        i--;
                    }
                }
                // Aggregate the list of tuples
                Tuple toAdd = new Tuple();
                for (int j = 0; j < columns.size(); j++) {
                    String colName = columns.get(j);
                    if (functions.get(j).isPresent()) {
                        toAdd.put(colName, functions.get(j).get().apply(temp));
                    } else {
                        toAdd.put(columns.get(j), temp.get(0).get(columns.get(j)));
                    }
                }
                result.addTuple(toAdd);
            }
            $GROUP[0].table = result;
        }.
    }
}

module sql.AggregateList {
    imports {
        java.util.Optional;
    }
    
    reference syntax {
        provides {
            AggregateList;
        }

        [LIST]  AggregateList <-- AggregateFunction "," AggregateList;
                AggregateList <-- AggregateFunction;
    }
}

module sql.AggregateFunctions {
    imports {
        java.util.Optional;
        sql.Aggregate;
        sql.Aggregate.AggregateFun;
    }

    reference syntax {
        provides {
            AggregateFunction;
        }
        requires {
            Id;
        }

        [COUNT] AggregateFunction <-- "COUNT" "(" Id ")";
        [STAR]  AggregateFunction <-- "COUNT" "(" "*" ")";
        [SUM]   AggregateFunction <-- "SUM" "(" Id ")";
        [AVG]   AggregateFunction <-- "AVG" "(" Id ")";
        [MIN]   AggregateFunction <-- "MIN" "(" Id ")";
        [MAX]   AggregateFunction <-- "MAX" "(" Id ")";
        [ID]    AggregateFunction <-- Id;

        categories:
            AggregateFunction = {"COUNT", "SUM", "AVG", "MIN", "MAX"};
    }

    role(evaluation) {
        [COUNT] .{
            $COUNT[0].value = "COUNT(" + $COUNT[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.COUNT, $COUNT[1].value);
            $COUNT[0].function = Optional.of(aggrFun);
        }.
        [STAR] .{
            $STAR[0].value = "COUNT(*)";
            Aggregate aggrFun = new Aggregate(AggregateFun.COUNT_STAR, null);
            $STAR[0].function = Optional.of(aggrFun);
        }.
        [SUM] .{
            $SUM[0].value = "SUM(" + $SUM[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.SUM, $SUM[1].value);
            $SUM[0].function = Optional.of(aggrFun);
        }.
        [AVG] .{
            $AVG[0].value = "AVG(" + $AVG[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.AVG, $AVG[1].value);
            $AVG[0].function = Optional.of(aggrFun);
        }.
        [MIN] .{
            $MIN[0].value = "MIN(" + $MIN[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.MIN, $MIN[1].value);
            $MIN[0].function = Optional.of(aggrFun);
        }.
        [MAX] .{
            $MAX[0].value = "MAX(" + $MAX[1].value + ")";
            Aggregate aggrFun = new Aggregate(AggregateFun.MAX, $MAX[1].value);
            $MAX[0].function = Optional.of(aggrFun);
        }.
        [ID] .{
            $ID[0].value = $ID[1].value;
            $ID[0].function = Optional.empty();
        }.
    }
}
