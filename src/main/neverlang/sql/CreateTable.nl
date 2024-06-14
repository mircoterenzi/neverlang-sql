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
            List<String> vars = AttributeList.collectFrom($declaration[2], "id");
            $$DatabaseMap.put($declaration[1].id, vars);
        }.
    }
}