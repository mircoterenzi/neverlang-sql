module sql.Insert {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }

    reference syntax {
        insert:
            Operation <-- "INSERT" "INTO" Id "(" IdList ")" "VALUES" "(" ValueList ")" ;
        ids:
            IdList <-- Id "," IdList;
            IdList <-- Id;
        values:
            ValueList <-- Value "," ValueList;
            ValueList <-- Value;
        value:
            Value <-- /[a-zA-Z0-9]+/;
    }

    role(evaluation) {
        value: .{
            $value.id = #0.text;
        }.
        insert: .{
            if (!$$DatabaseMap.containsKey($insert[1].id)) {
                throw new IllegalArgumentException("Unexpected value: \"" + $insert[1].id + "\" is not an existing table");
            }
            List<String> cols = AttributeList.collectFrom($insert[2], "id");
            List<Object> values = AttributeList.collectFrom($insert[3], "id");
            $$DatabaseMap.get($insert[1].id).addValues(cols, values);
        }.
    }
}