language sql.StructuredQueryLang {
    slices
        sql.CreateTable
        sql.DataDeclaration
        sql.DataList
        sql.ElementIdentifier
        sql.ElementType
    roles syntax < evaluation
    rename {
        Table --> Program;
    }
}