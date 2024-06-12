module sql.CreateTable {
    reference syntax {
        create:
            Table <-- "CREATE" "TABLE" Id "(" DataList ")";
    }

    role(evaluation) {
        create: .{
            System.out.println("Creata una tabella" + $create[1].value);    //todo: change role, now it print the table name just to be sure it's working
        }.
    }
}