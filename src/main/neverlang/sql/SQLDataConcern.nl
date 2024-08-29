bundle sql.SQLDataConcern {
    slices  sql.Insert
            sql.Delete
            sql.Update
            sql.SetList
            sql.Set
}

module sql.Insert {
    imports {
        java.util.List;
        neverlang.utils.AttributeList;
        sql.types.SQLType;
    }

    reference syntax {
        provides {
            Operation: insert;
        }
        requires {
            Id;
            IdList;
            ValueList;
        }

        [INSERT]
            Operation <-- "INSERT" "INTO" Id "(" IdList ")" "VALUES" "(" ValueList ")";

        categories:
            Clause = { "INSERT INTO", "VALUES" },
            Brackets = { "(", ")" };
    }

    role(evaluation) {
        [INSERT] @{
            List<String> headings = AttributeList.collectFrom($INSERT[2], "value");
            List<SQLType> values = AttributeList.collectFrom($INSERT[3], "value");
            Tuple tuple = new Tuple();
            for (int i=0; i<headings.size(); i++) {
                tuple.put(headings.get(i), values.get(i));
            }
            $$DatabaseMap.get($INSERT[1].value).addTuple(tuple);
        }.
    }
}

module sql.Delete {
    imports {
        java.util.List;
        neverlang.utils.AttributeList;
    }

    reference syntax {
        provides {
            Operation: delete;
        }
        requires {
            SelectedData;
        }

        [DELETE]
            Operation <-- "DELETE" SelectedData;

        categories:
            Clause = { "DELETE" };
    }

    role(evaluation) {
        [DELETE] .{
            eval $DELETE[1];
            String tableName = $DELETE[1].ref;
            Table table = $$DatabaseMap.get(tableName);
            Table toRemove = $DELETE[1].table;
            toRemove.getTuples().forEach(t -> table.removeTuple(t));
            $$DatabaseMap.put(tableName, table);
        }.
    }

    role(struct-checking) {
        [DELETE] .{
            $DELETE.isTerminal = true;
        }.
    }
}

module sql.Update {
    imports {
        java.util.List;
        java.util.function.Predicate;
        java.util.Map;
        java.util.HashMap;
        neverlang.utils.AttributeList;
        sql.Tuple;
        sql.types.SQLType;
    }

    reference syntax {
        provides {
            Operation: update;
        }
        requires {
            Id;
            BoolExpr;
        }

        [UPDATE]
            Operation <-- "UPDATE" Id "SET" SetList "WHERE" BoolExpr;

        categories:
            Clause = { "UPDATE", "SET", "WHERE" };
    }

    role(evaluation) {
        [UPDATE] @{
            String tableName = $UPDATE[1].value;
            Table table = $$DatabaseMap.get(tableName);
            Table result = table.copy();
            result.filterTuple(t -> false);
            Predicate<Tuple> predicate = $UPDATE[3].relation;
            Map<String, SQLType> toAdd = new HashMap<>();
            List<String> headings = AttributeList.collectFrom($UPDATE[2], "scope");
            List<SQLType> values = AttributeList.collectFrom($UPDATE[2], "value");
            for (int i=0; i<headings.size(); i++) {
                toAdd.put(headings.get(i), values.get(i));
            }

            table.getTuples().forEach(t -> {
                if (predicate.test(t)) {
                    Tuple newTuple = new Tuple();
                    t.keySet().forEach(key -> {
                        newTuple.put(key, toAdd.containsKey(key)? toAdd.get(key) :  t.get(key));
                    });
                    result.addTuple(newTuple);
                } else {
                    result.addTuple(t);
                }
            });
            $$DatabaseMap.put(tableName, result);
        }.
    }
}

module sql.SetList {
    reference syntax {
        provides {
            SetList;
        }
        requires {
            Set;
        }

        SetList <-- Set;
        SetList <-- SetList "," Set;

        categories:
            Operator = { "," };
    }
}

module sql.Set {
    reference syntax {
        provides {
            Set;
        }
        requires {
            Id;
            Value;
        }

        [SET] Set <-- Id "=" Value;

        categories:
            Operator = { "=" };
    }

    role(evaluation) {
        [SET] .{
            $SET[0].scope = $SET[1]:value;
            $SET[0].value = $SET[2]:value;
        }.
    }
}
