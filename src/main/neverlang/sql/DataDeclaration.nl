module sql.DataDeclaration {
    imports {
        java.util.ArrayList;
    }

    reference syntax {
        data:
            Data <-- Id Type;
        intType:
            Type <-- "INT";
        floatType:
            Type <-- "FLOAT";
        stringType:
            Type <-- "VARCHAR" "(" /[0-9]+/ ")";    //TODO: the number of char is fake atm
        boolType:
            Type <-- "BOOLEAN";
    }
    
    role(evaluation) {  //TODO: fix variable usage
        intType: .{
            $intType.var = new ArrayList<Integer>();
        }.
        floatType: .{
            $floatType.var = new ArrayList<Float>();
        }.
        stringType: .{
            $stringType.var = new ArrayList<String>();
        }.
        boolType: .{
            $boolType.var = new ArrayList<Boolean>();
        }.
        data: .{
            $data.var = $data[2].var;
            $data.id = $data[1].id;
        }.
    }
}