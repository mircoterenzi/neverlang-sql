language sql.SQLang {

    slices
        bundle (sql.SQLVariablesConcern)    // Defines all variables
        bundle (sql.SQLCoreConcern)     // Describes the core of the language: element identificator, operations, etc.
        bundle (sql.SQLTableConcern)    // Implements table operations: create, drop, alter.
                                        // Also defines columns and constraints needed in those operations.
        bundle (sql.SQLDataConcern)     // Implements data operations: insert, update, delete.
        bundle (sql.SQLBoolExprConcern) // Defines boolean expressions.
        bundle (sql.SQLDataOpConcern)   // Implements data operations: select, where, order by.
        bundle (sql.SQLAggregateFunConcern) // Implements aggregate functions and group by construct.

    endemic slices
        sql.SQLDatabaseMapEndemic
        sql.SQLAlgorithmsEndemic

    roles syntax <+ struct-checking <+ evaluation <+ output
}
