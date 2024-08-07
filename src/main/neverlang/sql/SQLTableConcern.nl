bundle sql.SQLTableConcern {
    slices  sql.CreateTable
            sql.DropTable
            sql.AlterTable
}

module sql.CreateTable {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }
    
    reference syntax {
        declaration:
            Operation <-- "CREATE" "TABLE" Id "(" DataList ")";
    }

    role(evaluation) {
        declaration: .{
            eval $declaration[1];
            eval $declaration[2];
            List<String> ids = AttributeList.collectFrom($declaration[2], "id");
            List<Types> types = AttributeList.collectFrom($declaration[2], "var");
            var table = new Table();
            for (int i=0; i<ids.size(); i++) {
                table.addColumn(ids.get(i), types.get(i));
            }
            $$DatabaseMap.put($declaration[1].id, table);
        }.
    }
}

module sql.DropTable {
    reference syntax {
        drop:
            Operation <-- "DROP" "TABLE" Id;
    }

    role(evaluation) {
        drop: .{
            String id = $drop[1]:id;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + id + "\" is not an existing table"
                );
            }
            $$DatabaseMap.remove(id);
        }.
    }
}

module sql.AlterTable {
    reference syntax {
        alter:
            AlterTable <-- "ALTER" "TABLE" Id;
        add:
            Operation <-- AlterTable "ADD" Data;
        drop:
            Operation <-- AlterTable "DROP" Id;
    }

    role(evaluation) {
        alter: .{
            String id = $alter[1]:id;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + id + "\" is not an existing table"
                );
            }
            $alter.id = id;
        }.
    }

    role(register) {
        add: @{
            $$DatabaseMap.get($add[1].id).addColumn($add[2].id, $add[2].var);
        }.
        drop: @{
            $$DatabaseMap.get($drop[1].id).removeColumn($drop[2].id);
        }.
    }
}