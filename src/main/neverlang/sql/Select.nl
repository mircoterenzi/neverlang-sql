module sql.Select {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }

    reference syntax {
        select:
            Operation <-- "SELECT" IdList "FROM" Id;
        selectAll:
            Operation <-- "SELECT" "*" "FROM" Id;
    }

    role(evaluation) {
        select: .{
            String id = $select[2].id;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException("Unexpected value: \"" + id + "\" is not an existing table");
            }
            List<String> ids = AttributeList.collectFrom($select[1], "id");
            System.out.println($$DatabaseMap.get(id).getValues(ids).toString());
        }.
        selectAll: .{
            String id = $selectAll[1].id;
            if (!$$DatabaseMap.containsKey(id)) {
                throw new IllegalArgumentException("Unexpected value: \"" + id + "\" is not an existing table");
            }
            System.out.println($$DatabaseMap.get(id).getValues().toString());
        }.
    }
}