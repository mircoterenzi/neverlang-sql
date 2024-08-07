language sql.SQLang {
    slices
        sql.CreateTable
        sql.DataDeclaration
        sql.DataList
        sql.ElementIdentifier
        sql.IdList
        sql.AlterTable
        sql.DropTable
        sql.Insert
        sql.Select
        sql.Value
        sql.ValueList
        sql.OperationList
    endemic slices
        sql.DatabaseCache
    roles syntax < values < evaluation <+ register
    rename {
        OperationList --> Program;
    }
}