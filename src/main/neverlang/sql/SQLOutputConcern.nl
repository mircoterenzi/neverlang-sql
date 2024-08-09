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
            List<List<Object>> lists = $PRINT[1].data;
            var sb = new StringBuilder();
            for (int i=0; i<lists.get(0).size(); i++) {
                for (List<Object> list : lists) {
                    sb.append(list.get(i) + " ");
                }
                sb.append("\n");
            }
            System.out.println(sb.toString());
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
    }

    reference syntax {
        [TABLE]
            SelectedData <-- "SELECT" "*" SelectedTable;
        [COLUMN_LIST]
            SelectedData <-- "SELECT" IdList SelectedTable;
    }

    role(evaluation) {
        [TABLE] .{
            $TABLE[0].headings = $$DatabaseMap.get($TABLE[1].value).getHeadings();
            $TABLE[0].data = $$DatabaseMap.get($TABLE[1].value).get();
        }.
        [COLUMN_LIST] @{
            $COLUMN_LIST[0].headings = AttributeList.collectFrom($COLUMN_LIST[1], "value");
            $COLUMN_LIST[0].data = $$DatabaseMap.get($COLUMN_LIST[2].value).get();
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