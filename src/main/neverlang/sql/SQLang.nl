language sql.SQLang {

    slices
        bundle (sql.SQLVariablesConcern)
        bundle (sql.SQLDeclarationConcern)
        bundle (sql.SQLCoreConcern)
        bundle (sql.SQLTableConcern)
        bundle (sql.SQLOutputConcern)
        sql.Insert

    endemic slices
        sql.DatabaseCache

    roles syntax < evaluation <+ register

    rename {
        OperationList --> Program;
    }
    
}