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
            List<String> ids = AttributeList.collectFrom($declaration[2], "value");
            List<Types> types = AttributeList.collectFrom($declaration[2], "type");
            List<Boolean> not_nullity = AttributeList.collectFrom($declaration[2], "isNotNull");
            List<Boolean> uniqueness = AttributeList.collectFrom($declaration[2], "isUnique");
            Table table = new Table();
            for (int i=0; i<ids.size(); i++) {
                table.add(ids.get(i), types.get(i), not_nullity.get(i), uniqueness.get(i));
            }
            $$DatabaseMap.put($declaration[1].value, table);
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
            String id = $drop[1]:value;
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
            String id = $alter[1]:value;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + id + "\" is not an existing table"
                );
            }
            $alter.value = id;
        }.
    }

    role(register) {
        add: @{
            $$DatabaseMap.get($add[1].value).add($add[2].value, $add[2].type);
        }.
        drop: @{
            $$DatabaseMap.get($drop[1].value).remove($drop[2].value);
        }.
    }
}
