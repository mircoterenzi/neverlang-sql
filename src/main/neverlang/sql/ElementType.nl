module sql.ElementType {
    reference syntax {
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
            $intType.value = Integer.class;
            System.out.println("new int");      //todo: remove debug prints
        }.
        doubleType: .{
            $doubleType.value = Double.class;
            System.out.println("new double");
        }.
        stringType: .{
            $stringType.value = String.class;
            System.out.println("new string");
        }.
        boolType: .{
            $boolType.value = Boolean.class;
            System.out.println("new bool");
        }.
    }
}