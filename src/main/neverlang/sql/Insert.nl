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
        insert: .{
            eval $insert[1];
            eval $insert[2];
            eval $insert[3];

            List<String> cols = AttributeList.collectFrom($insert[2], "id");
            List<Object> values = AttributeList.collectFrom($insert[3], "id");

            $$DatabaseMap.get($insert[1].id).addValues(cols, values);
        }.
    }
}