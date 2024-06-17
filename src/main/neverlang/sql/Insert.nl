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
        string: //todo: splitted value into string and number because the last regex was not working
            Value <-- /[a-zA-Z]+/;
        number:
            Value <-- /[0-9]+/;
    }

    role(evaluation) {
        string: .{
            $string.id = #0.text;
        }.
        number: .{
            $number.id = #0.text;
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