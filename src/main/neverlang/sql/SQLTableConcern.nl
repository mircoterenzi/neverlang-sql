bundle sql.SQLTableConcern {
    slices  sql.CreateTable
            sql.DropTable
            sql.AlterTable
}

module sql.CreateTable {
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
    }
}

module sql.DropTable {
    reference syntax {
        provides {
            Operation;
        }
        requires {
            Id;
        }
        
        drop:
            Operation <-- "DROP" "TABLE" Id;
    }

    role(evaluation) {
        drop: .{
            $$DatabaseMap.remove($drop[1]:value);
        }.
    }
}

module sql.AlterTable {
    imports {
        java.util.Optional;
    }
    
    reference syntax {
        provides {
            SelectedTable;
            Operation;
        }
        requires {
            Id;
            Column;
        }

        alter:
            SelectedTable <-- "ALTER" "TABLE" Id;
        add:
            Operation <-- SelectedTable "ADD" Column;
        drop:
            Operation <-- SelectedTable "DROP" Id;
    }

    role(evaluation) {
        alter: .{
            $alter.value = $alter[1]:value;
        }.
    }

    role(register) {
        add: @{
            $$DatabaseMap.get($add[1].value).addColumn($add[2].column);
        }.
        drop: @{
            $$DatabaseMap.get($drop[1].value).removeColumn($drop[2].value);
        }.
    }
}

