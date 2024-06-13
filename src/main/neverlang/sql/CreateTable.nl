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
            System.out.println("Creata una tabella: " + $declaration[1].id);    //todo: change role, now it print the table name just to be sure it's working
            Table table = new Table($declaration[1].id);
            $declaration.table = table;
            List<String> vars = AttributeList.collectFrom($declaration[2], "id");
            System.out.print("Contenente: ");
            for (String curr : vars) {
                System.out.print(curr + " ");
            }
        }.
    }
}