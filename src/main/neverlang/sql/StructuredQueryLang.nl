language sql.StructuredQueryLang {
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
    roles syntax < ids < evaluation <+ register
    rename {
        OperationList --> Program;
    }
}