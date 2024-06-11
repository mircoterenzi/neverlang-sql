module sql.ElementType {
    reference syntax {
        elemType:
            Type <-- /(Int|Double|String|Bool)/;    //todo: atm is not working
    }

    role(evaluation) {
        elemType: .{
            switch(#0.text) {
                case "Int": 
                    $elemType.value = Integer.class;
                    break;
                case "Double":
                    $elemType.value = Double.class;
                    break;
                case "String":
                    $elemType.value = String.class;
                    break;
                case "Bool":
                    $elemType.value = Boolean.class;
                    break;
                default:
            }
        }.
    }
}