language sql.SQLang {

    slices
        bundle (sql.SQLVariablesConcern)
        bundle (sql.SQLColumnConcern)
        bundle (sql.SQLCoreConcern)
        bundle (sql.SQLTableConcern)
        bundle (sql.SQLDataOpConcern)
        bundle (sql.SQLDataIOConcern)
        bundle (sql.SQLBoolExprConcern)
        bundle (sql.SQLAggregateFunConcern)

    endemic slices
        sql.SQLDatabaseMapEndemic
        sql.SQLAlgorithmsEndemic

    roles syntax < evaluation <+ register

    rename {
        OperationList --> Program;
    }
    
}
