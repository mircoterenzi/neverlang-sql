language sql.StructuredQueryLang {
    slices
        sql.CreateTable
        sql.DataDeclaration
        sql.DataList
        sql.ElementIdentifier
        sql.AlterTable
    endemic slices
        sql.DatabaseCache
    roles syntax < evaluation
    rename {
        Table --> Program;
    }
}