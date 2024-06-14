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
            List<String> ids = AttributeList.collectFrom($declaration[2], "id");
            List<List<Object>> vars = AttributeList.collectFrom($declaration[2], "var");
            var table = new Table();
            for (int i=0; i<ids.size(); i++) {
                table.add(ids.get(i), vars.get(i));
            }
            $$DatabaseMap.put($declaration[1].id, table);
        }.
    }
}