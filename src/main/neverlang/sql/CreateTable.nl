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