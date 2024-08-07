language sql.SQLang {

    slices
        bundle (sql.SQLVariablesConcern)
        bundle (sql.SQLDeclarationConcern)
        bundle (sql.SQLCoreConcern)
        bundle (sql.SQLTableConcern)
        sql.Insert
        sql.Select

    endemic slices
        sql.DatabaseCache

    roles syntax < evaluation <+ register

    rename {
        OperationList --> Program;
    }
    
}