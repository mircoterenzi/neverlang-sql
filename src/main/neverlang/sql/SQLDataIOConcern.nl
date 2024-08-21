bundle sql.SQLDataIOConcern {
    slices  sql.Insert
            sql.Delete
            sql.Update
            sql.SetList
            sql.Set
}

module sql.Insert {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
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

        insert:
            Operation <-- "INSERT" "INTO" Id "(" IdList ")" "VALUES" "(" ValueList ")";

    }

    role(evaluation) {
        insert: .{
            List<String> headings = AttributeList.collectFrom($insert[2], "value");
            List<SQLType> values = AttributeList.collectFrom($insert[3], "value");
            Tuple tuple = new Tuple();
            for (int i=0; i<headings.size(); i++) {
                tuple.put(headings.get(i), values.get(i));
            }
            $$DatabaseMap.get($insert[1].value).addTuple(tuple);
        }.
    }
}

module sql.Delete {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }

    reference syntax {
        provides {
            Operation: delete;
        }
        requires {
            SelectedData;
        }

        delete:
            Operation <-- "DELETE" SelectedData;
    }

    role(evaluation) {
        delete: .{
            String tableName = $delete[1].ref;
            Table table = $$DatabaseMap.get(tableName);
            Table toRemove = $delete[1].table;
            toRemove.getTuples().forEach(t -> table.removeTuple(t));
            $$DatabaseMap.put(tableName, table);
        }.
    }
}

module sql.Update {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
        java.util.function.Predicate;
        java.util.Map;
        java.util.HashMap;
        sql.Tuple;
        sql.types.SQLType;
    }

    reference syntax {
        provides {
            Operation: update;
        }
        requires {
            Id;
            RelExpr;
        }

        update:
            Operation <-- "UPDATE" Id "SET" SetList "WHERE" RelExpr;
    }

    role(evaluation) {
        update: .{
            String tableName = $update[1].value;
            Table table = $$DatabaseMap.get(tableName);
            Table result = table.copy().filterTuple(t -> false);
            Predicate<Tuple> predicate = $update[3].relation;
            Map<String, SQLType> toAdd = new HashMap<>();
            List<String> headings = AttributeList.collectFrom($update[2], "scope");
            List<SQLType> values = AttributeList.collectFrom($update[2], "value");
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

        [SET]       SetList <-- Set;
        [CONCAT]    SetList <-- SetList "," Set;
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
    }

    role(evaluation) {
        [SET] .{
            $SET[0].scope = $SET[1].value;
            $SET[0].value = $SET[2].value;
        }.
    }
}
