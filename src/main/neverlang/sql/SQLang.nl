language sql.SQLang {

    slices
        bundle (sql.SQLVariablesConcern)    
        bundle (sql.SQLCoreConcern)
        bundle (sql.SQLTableConcern)
        bundle (sql.SQLDataOpConcern)
        bundle (sql.SQLDataConcern)
        bundle (sql.SQLBoolExprConcern)
        bundle (sql.SQLAggregateFunConcern)

    endemic slices
        sql.SQLDatabaseMapEndemic
        sql.SQLAlgorithmsEndemic

    roles syntax <+ struct-checking <+ evaluation <+ output
}
