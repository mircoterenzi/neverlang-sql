language sql.StructuredQueryLang {
    slices
        sql.CreateTable
        sql.DataDeclaration
        sql.DataList
        sql.ElementIdentifier
        sql.AlterTable
    roles syntax < evaluation
    rename {
        Table --> Program;
    }
}