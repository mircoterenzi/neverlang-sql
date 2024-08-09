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
            List<String> headings = AttributeList.collectFrom($insert[2], "value");
            List<Object> values = AttributeList.collectFrom($insert[3], "value");
            Tuple tuple = new Tuple();
            for (int i=0; i<headings.size(); i++) {
                tuple.put(headings.get(i), values.get(i));
            }
            $$DatabaseMap.get($insert[1].value).insertTuple(tuple);
        }.
    }
}