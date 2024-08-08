module sql.Insert {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }

    reference syntax {
        insert:
            Operation <-- "INSERT" "INTO" Id "(" IdList ")" "VALUES" "(" ValueList ")";

    }

    role(evaluation) {
        insert: @{
            List<String> cols = AttributeList.collectFrom($insert[2], "value");
            List<Object> values = AttributeList.collectFrom($insert[3], "value");
            $$DatabaseMap.get($insert[1].value).addValues(cols, values);
        }.
    }
}