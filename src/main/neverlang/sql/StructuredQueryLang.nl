language sql.StructuredQueryLang {
    slices
        sql.CreateTable
        sql.DataDeclaration
        sql.DataList
        sql.ElementIdentifier
    roles syntax < evaluation
    rename {
        Table --> Program;
    }
}