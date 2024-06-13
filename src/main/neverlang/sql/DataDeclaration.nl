module sql.DataDeclaration {
    imports {
        java.util.ArrayList;
    }
    reference syntax {
        data:
            Data <-- Id Type;
        intType:
            Type <-- "int";
        doubleType:
            Type <-- "double";
        stringType:
            Type <-- "string";
        boolType:
            Type <-- "bool";
    }
    role(evaluation) {
        intType: .{
            $intType.var = new ArrayList<Integer>();
        }.
        doubleType: .{
            $doubleType.var = new ArrayList<Double>();
        }.
        stringType: .{
            $stringType.var = new ArrayList<String>();
        }.
        boolType: .{
            $boolType.var = new ArrayList<Boolean>();
        }.
        data: .{
            String id = $data[1].id;
            $data.var = $data[2].var;
            $data.id = id;
        }.
    }
}