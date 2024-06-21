module sql.DataDeclaration {
    reference syntax {
        data:
            Data <-- Id Type;
        intType:
            Type <-- "INT";
        floatType:
            Type <-- "FLOAT";
        stringType:
            Type <-- "VARCHAR" "(" Integer ")";    //TODO: the number of char is fake atm
        boolType:
            Type <-- "BOOLEAN";
    }
    
    role(evaluation) {
        intType: .{
            $intType.var = Types.INT;
        }.
        floatType: .{
            $floatType.var = Types.FLOAT;
        }.
        stringType: .{
            $stringType.var = Types.VARCHAR;
        }.
        boolType: .{
            $boolType.var = Types.BOOLEAN;
        }.
        data: .{
            $data.var = $data[2].var;
            $data.id = $data[1].id;
        }.
    }
}