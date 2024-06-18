module sql.Select {
    imports {
        neverlang.utils.AttributeList;
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

            System.out.println(
                $$DatabaseMap.get($select[2].id)
                        .getValues(AttributeList.collectFrom($select[1], "id"))
                        .toString()
            );
        }.
        selectAll: .{
            eval $selectAll[1];

            if (!$$DatabaseMap.containsKey($selectAll[1].id)) {
                throw new IllegalArgumentException(
                    "Unexpected value: \"" + $selectAll[1].id + "\" is not an existing table"
                );
            }

            System.out.println($$DatabaseMap.get($selectAll[1].id).getValues().toString());
        }.
    }
}