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
        }

        [GROUP] SelectedData <-- "SELECT" AggregateList SelectedData "GROUP" "BY" IdList;
    }

    role(evaluation) {
        [GROUP] .{
            eval $GROUP[1];

            List<String> columns = AttributeList.collectFrom($GROUP[1],"value");
            List<Optional<Aggregates>> functions = AttributeList.collectFrom($GROUP[1],"function");
            List<String> groupByColumns = AttributeList.collectFrom($GROUP[3],"value");
            Table table = $GROUP[2].table;
            List<Tuple> data = table.getTuples();
            Table result = table.select(t -> false);

            // Remove unwanted columns
            result.getColumnNames().stream()
                    .filter(column -> !columns.contains(column))
                    .forEach(result::removeColumn);

            // Checks if all the columns are used in an aggregate function
            for (int i = 0; i < columns.size(); i++) {
                if (!groupByColumns.contains(columns.get(i))) {
                    result.removeColumn(columns.get(i));
                    if (!functions.get(i).isPresent()) {
                        throw new RuntimeException("Column " + columns.get(i) + " must be used in an aggregate function");
                    } else {
                        Column col = new Column(null, false, false, null);
                        result.addColumn(columns.get(i), col);
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
                        toAdd.put(colName, functions.get(j).get().apply(temp.stream().map(t -> t.get(colName)).toList()));
                    } else {
                        toAdd.put(columns.get(j), temp.get(0).get(columns.get(j)));
                    }
                }
                result.insertTuple(toAdd);
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
    }

    reference syntax {
        provides {
            AggregateFunction;
        }
        requires {
            Id;
        }

        [COUNT] AggregateFunction <-- "COUNT" "(" Id ")";
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
            $COUNT[0].value = $COUNT[1].value;
            $COUNT[0].function = Optional.of(Aggregates.COUNT);
        }.
         [SUM] .{
            $SUM[0].value = $SUM[1].value;
            $SUM[0].function = Optional.of(Aggregates.SUM);
        }.
        [AVG] .{
            $AVG[0].value = $AVG[1].value;
            $AVG[0].function = Optional.of(Aggregates.AVG);
        }.
        [MIN] .{
            $MIN[0].value = $MIN[1].value;
            $MIN[0].function = Optional.of(Aggregates.MIN);
        }.
        [MAX] .{
            $MAX[0].value = $MAX[1].value;
            $MAX[0].function = Optional.of(Aggregates.MAX);
        }.
        [ID] .{
            $ID[0].value = $ID[1].value;
            $ID[0].function = Optional.empty();
        }.
    }
}
