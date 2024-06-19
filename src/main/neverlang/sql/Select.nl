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
            eval $select[1];
            eval $select[2];

            if (!$$DatabaseMap.containsKey($select[2].id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + $select[2].id + "\" is not an existing table"
                );
            }

            var lists = $$DatabaseMap.get($select[2].id).getValues(AttributeList.collectFrom($select[1], "id"));
            var sb = new StringBuilder();

            for (int i=0; i<lists.get(0).size(); i++) {
                for (List<Object> list : lists) {
                    sb.append(list.get(i) + " ");
                }
                sb.append("\n");
            }
            System.out.println(sb.toString());
        }.
        selectAll: .{
            eval $selectAll[1];

            if (!$$DatabaseMap.containsKey($selectAll[1].id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + $selectAll[1].id + "\" is not an existing table"
                );
            }

            System.out.println($$DatabaseMap.get($selectAll[1].id).toString());
        }.
    }
}