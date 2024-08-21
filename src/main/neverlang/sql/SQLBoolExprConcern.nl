bundle sql.SQLBoolExprConcern {
    slices  sql.BoolConcatenation
            sql.RelationalExpression
            sql.ComplexExpression
}

module sql.BoolConcatenation {
    imports {
        java.util.function.Predicate;
    }

    reference syntax {
        provides {
            BoolExpr;
        }
        requires {
            BoolExpr;
        }

        [AND]   BoolExpr <-- BoolExpr "AND" BoolExpr;
        [OR]    BoolExpr <-- BoolExpr "OR" BoolExpr;
        [NOT]   BoolExpr <-- "NOT" BoolExpr;

        categories:
            BoolOperator = {"AND", "OR", "NOT"};
    }

    role(evaluation) {
        [AND] .{
            Predicate<Tuple> filter = obj -> ((Predicate<Tuple>) $AND[1].relation).test(obj) && ((Predicate<Tuple>) $AND[2].relation).test(obj);
            $AND[0].relation = (Predicate<Tuple>) filter;
        }.
        [OR] .{
            Predicate<Tuple> filter = obj -> ((Predicate<Tuple>) $OR[1].relation).test(obj) || ((Predicate<Tuple>) $OR[2].relation).test(obj);
            $OR[0].relation = filter;
        }.
        [NOT] .{
            Predicate<Tuple> filter = obj -> !((Predicate<Tuple>) $NOT[1].relation).test(obj);
            $NOT[0].relation = filter;
        }.
    }
}

module sql.RelationalExpression {
    imports {
        java.util.function.Predicate;
        sql.Tuple;
        sql.types.SQLType;
    }

    reference syntax {
        provides {
            BoolExpr;
        }
        requires {
            Id;
            Value;
        }

        [EQ]       BoolExpr <-- Id "=" Value;
        [NEQ]      BoolExpr <-- Id "<>" Value;
        [NEQ_ALT]  BoolExpr <-- Id "!=" Value;
        [LT]       BoolExpr <-- Id "<" Value;
        [LTE]      BoolExpr <-- Id "<=" Value;
        [GT]       BoolExpr <-- Id ">" Value;
        [GTE]      BoolExpr <-- Id ">=" Value;

        categories:
            Operator = {"=", "<>", "!=", "<", "<=", ">", ">="};
    }

    role(evaluation) {
        [EQ] .{
            $EQ[0].scope = $EQ[1].value;
            Predicate<Tuple> relation = tuple -> {
                SQLType value = tuple.get($EQ[1].value);
                return value != null && value.equals($EQ[2].value);
            };
            $EQ[0].relation = relation;
        }.
        [NEQ] .{
            $NEQ[0].scope = $NEQ[1].value;
            Predicate<Tuple> relation = tuple -> {
                SQLType value = tuple.get($NEQ[1].value);
                return value != null && !value.equals($NEQ[2].value);
            };
            $NEQ[0].relation = relation;
        }.
        [NEQ_ALT] .{
            $NEQ_ALT[0].scope = $NEQ_ALT[1].value;
            Predicate<Tuple> relation = tuple -> {
                SQLType value = tuple.get($NEQ_ALT[1].value);
                return value != null && !value.equals($NEQ_ALT[2].value);
            };
            $NEQ_ALT[0].relation = relation;
        }.
        [LT] .{
            $LT[0].scope = $LT[1].value;
            Predicate<Tuple> relation = tuple -> {
                SQLType value = tuple.get($LT[1].value);
                return value != null && value.compareTo($LT[2].value) < 0;
            };
            $LT[0].relation = relation;
        }.
        [LTE] .{
            $LTE[0].scope = $LTE[1].value;
            Predicate<Tuple> relation = tuple -> {
                SQLType value = tuple.get($LTE[1].value);
                return value != null && value.compareTo($LTE[2].value) <= 0;
            };
            $LTE[0].relation = relation;
        }.
        [GT] .{
            $GT[0].scope = $GT[1].value;
            Predicate<Tuple> relation = tuple -> {
                SQLType value = tuple.get($GT[1].value);
                return value != null && value.compareTo($GT[2].value) > 0;
            };
            $GT[0].relation = relation;
        }.
        [GTE] .{
            $GTE[0].scope = $GTE[1].value;
            Predicate<Tuple> relation = tuple -> {
                SQLType value = tuple.get($GTE[1].value);
                return value != null && value.compareTo($GTE[2].value) >= 0;
            };
            $GTE[0].relation = relation;
        }.
    }
}

module sql.ComplexExpression {
    imports {
        java.util.function.Predicate;
        java.util.List;
        neverlang.utils.AttributeList;
        sql.Tuple;
        sql.types.SQLType;
    }

    reference syntax {
        provides {
            BoolExpr;
        }

        requires {
            Id;
            Value;
            ValueList;
        }   

        [BTW]   BoolExpr <-- Id "BETWEEN" Value "AND" Value;
        [IN]    BoolExpr <-- Id "IN" "(" ValueList ")";
        [NULL]  BoolExpr <-- Id "IS" "NULL";

        categories:
            Operator = {"BETWEEN", "IN", "IS NULL"};
    }

    role(evaluation) {
        [BTW] .{
            $BTW[0].scope = $BTW[1].value;
            Predicate<Tuple> relation = tuple -> {
                return tuple.get($BTW[1].value).compareTo($BTW[2].value) >= 0 && 
                        tuple.get($BTW[1].value).compareTo($BTW[3].value) <= 0;
            };
            $BTW[0].relation = relation;
        }.
        [IN] .{
            $IN[0].scope = $IN[1].value;
            List<SQLType> values = AttributeList.collectFrom($IN[2], "value");
            Predicate<Tuple> relation = tuple -> {
                SQLType value = tuple.get($IN[1].value);
                return values.contains(value);
            };
            $IN[0].relation = relation;
        }.
        [NULL] .{
            $NULL[0].scope = $NULL[1].value;
            Predicate<Tuple> relation = tuple -> tuple.get($NULL[1].value) == null;
            $NULL[0].relation = relation;
        }.
    }
}
