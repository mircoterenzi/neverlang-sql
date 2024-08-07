bundle sql.SQLDeclarationConcern {
    slices  sql.DataDeclaration
            sql.DataList
}

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
            $intType.type = Types.INT;
        }.
        floatType: .{
            $floatType.type = Types.FLOAT;
        }.
        stringType: .{
            $stringType.type = Types.VARCHAR;
        }.
        boolType: .{
            $boolType.type = Types.BOOLEAN;
        }.
        data: .{
            $data.type = $data[2]:type;
            $data.value = $data[1]:value;
        }.
    }
}

module sql.DataList {
    reference syntax {
        DataList <-- Data "," DataList;
        DataList <-- Data;
    }
}