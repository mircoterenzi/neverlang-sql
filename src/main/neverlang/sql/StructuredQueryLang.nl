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
    endemic slices
        sql.DatabaseCache
    roles syntax < evaluation
    rename {
        OperationList --> Program;
    }
}