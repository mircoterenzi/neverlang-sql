language sql.SQLang {

    slices
        bundle (sql.SQLVariablesConcern)
        bundle (sql.SQLColumnConcern)
        bundle (sql.SQLCoreConcern)
        bundle (sql.SQLTableConcern)
        bundle (sql.SQLDataManipulationConcern)
        bundle (sql.SQLDataIOConcern)
        bundle (sql.SQLRelExprConcern)
        bundle (sql.SQLBoolExprConcern)

    endemic slices
        sql.DatabaseCache

    roles syntax < evaluation <+ register

    rename {
        OperationList --> Program;
    }
    
}
