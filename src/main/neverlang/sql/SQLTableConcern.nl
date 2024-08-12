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
            List<String> ids = AttributeList.collectFrom($declaration[2], "value");
            List<Types> types = AttributeList.collectFrom($declaration[2], "type");
            List<Boolean> not_nullity = AttributeList.collectFrom($declaration[2], "isNotNull");
            List<Boolean> uniqueness = AttributeList.collectFrom($declaration[2], "isUnique");
            Table table = new Table();
            for (int i=0; i<ids.size(); i++) {
                Column column = new Column(types.get(i), not_nullity.get(i), uniqueness.get(i), Optional.empty());
                table.addColumn(ids.get(i), column);
            }
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
            ColumnList;
        }

        alter:
            SelectedTable <-- "ALTER" "TABLE" Id;
        add:
            Operation <-- SelectedTable "ADD" ColumnList;
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
            Column column = new Column($add[2].type, false, false, Optional.empty());
            $$DatabaseMap.get($add[1].value).addColumn($add[2].value, column);
        }.
        drop: @{
            $$DatabaseMap.get($drop[1].value).removeColumn($drop[2].value);
        }.
    }
}

