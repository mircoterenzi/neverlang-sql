module sql.CreateTable {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }
    reference syntax {
        declaration:
            Table <-- "CREATE" "TABLE" Id "(" DataList ")";
    }

    role(evaluation) {
        declaration: .{
            List<String> vars = AttributeList.collectFrom($declaration[2], "id");
            Table table = new Table($declaration[1].id, vars);
            $declaration.table = table;
        }.
    }
}