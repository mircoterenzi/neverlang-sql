bundle sql.SQLOutputConcern {
    slices  sql.PrintData
            sql.ColumnSelector
            sql.TableSelector
            sql.OrderBy
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
            System.out.println($PRINT[1].table.toString());
            $$DatabaseMap.put("OUTPUT", $PRINT[1].table);
        }.
    }
}

module sql.TableSelector {
    reference syntax {
        [TABLE]
            SelectedTable <-- "FROM" Id;
    }

    role(evaluation) {
        [TABLE] .{
            eval $TABLE[1];
            if (!$$DatabaseMap.containsKey($TABLE[1].value)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + $TABLE[1].value + "\" is not an existing table"
                );
            }
            $TABLE[0].value = $TABLE[1].value;
        }.
    }
}

module sql.ColumnSelector {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }

    reference syntax {
        [TABLE]
            SelectedData <-- "SELECT" "*" SelectedTable;
        [COLUMN_LIST]
            SelectedData <-- "SELECT" IdList SelectedTable;
    }

    role(evaluation) {
        [TABLE] .{
            $TABLE[0].table = $$DatabaseMap.get($TABLE[1].value);
        }.
        [COLUMN_LIST] @{
            Table table = $$DatabaseMap.get($COLUMN_LIST[2].value).copy();
            List<String> columns = AttributeList.collectFrom($COLUMN_LIST[1],"value");
            table.getColumnNames().stream()
                    .filter(column -> !columns.contains(column))
                    .forEach(table::removeColumn);
            $COLUMN_LIST[0].table = table;
        }.
    }
}

module sql.OrderBy {
    imports {
        java.util.List;
        java.util.ArrayList;
    }

    reference syntax {
        [WHERE]
            SelectedData <-- SelectedData "ORDER" "BY" Id;
    }

    role(evaluation) {
        [WHERE] .{
            //TODO: order data from $WHERE[1].data
        }.
    }
}