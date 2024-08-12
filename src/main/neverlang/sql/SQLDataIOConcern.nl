bundle sql.SQLDataIOConcern {
    slices  sql.Insert
            sql.Delete
            sql.Update
}

module sql.Insert {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
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
            List<Object> values = AttributeList.collectFrom($insert[3], "value");
            Tuple tuple = new Tuple();
            for (int i=0; i<headings.size(); i++) {
                tuple.put(headings.get(i), values.get(i));
            }
            $$DatabaseMap.get($insert[1].value).insertTuple(tuple);
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
        delete: @{
            //TODO: Implement
        }.
    }
}

module sql.Update {
    imports {
        neverlang.utils.AttributeList;
        java.util.List;
    }

    reference syntax {
        provides {
            Operation: update;
        }
        requires {
            Id;
            BoolExpr;
        }

        update:
            Operation <-- "UPDATE" Id "SET" SetList "WHERE" BoolExpr;
    }

    role(evaluation) {
        update: @{
            //TODO: Implement
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
