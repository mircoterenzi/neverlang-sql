bundle sql.SQLDataManipulationConcern {
    slices  sql.PrintData
            sql.TableSelector
            //sql.Select
            sql.Where
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
        }.
    }
}
/* TODO: fix this module (blend it with the filterTuple + group-by module)
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
        [TABLE] @{
            $TABLE[0].table = $TABLE[1].table;
        }.
        [COLUMN_LIST] @{
            Table table = $COLUMN_LIST[2].table;
            List<String> columns = AttributeList.collectFrom($COLUMN_LIST[1],"value");
            table.getColumnNames().stream()
                    .filter(column -> !columns.contains(column))
                    .forEach(table::removeColumn);
            $COLUMN_LIST[0].table = table;
        }.
    }
}
*/
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
            RelExpr;
        }

        [WHERE] SelectedData <-- SelectedData "WHERE" RelExpr;
    }

    role (evaluation) {
        [WHERE] .{
            $WHERE[0].table = ((Table) $WHERE[1].table).copy().filterTuple((Predicate<Tuple>) $WHERE[2].relation);
        }.
    }
}

module sql.OrderBy {
    imports {
        java.util.List;
        neverlang.utils.AttributeList;
    }

    reference syntax {
        [WHERE]
            SelectedData <-- SelectedData "ORDER" "BY" IdList;      //TODO: implement the possibility to specify ASC or DESC
    }

    role(evaluation) {
        [WHERE] .{
            List<String> columns = AttributeList.collectFrom($WHERE[2], "value");
            $WHERE[0].table = $$Algorithms.sortTable($WHERE[1].table, columns);
        }.
    }
}