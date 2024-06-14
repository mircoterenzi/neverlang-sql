language sql.StructuredQueryLang {
    slices
        sql.CreateTable
        sql.DataDeclaration
        sql.DataList
        sql.ElementIdentifier
        sql.AlterTable
        sql.OperationList
        sql.DropTable
    endemic slices
        sql.DatabaseCache
    roles syntax < evaluation
    rename {
        OperationList --> Program;
    }
}