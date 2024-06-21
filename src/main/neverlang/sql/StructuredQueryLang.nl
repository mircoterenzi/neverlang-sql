language sql.StructuredQueryLang {
    slices
        sql.CreateTable
        sql.DataDeclaration
        sql.DataList
        sql.ElementIdentifier
        sql.IdList
        sql.AlterTable
        sql.OperationList
        sql.DropTable
        sql.Insert
        sql.Select
        sql.Value
        sql.ValueList
    endemic slices
        sql.DatabaseCache
    roles syntax < evaluation <+ register
    rename {
        OperationList --> Program;
    }
}