bundle sql.SQLRelExprConcern {
    slices  sql.RelationalExpression
            sql.ComplexExpression
}

module sql.RelationalExpression {
    imports {
        java.util.function.Predicate;
        sql.Tuple;
    }

    reference syntax {
        provides {
            RelExpr;
        }
        requires {
            Id;
            Value;
        }

        [EQ]       RelExpr <-- Id "=" Value;
        [NEQ]      RelExpr <-- Id "<>" Value;
        [NEQ_ALT]  RelExpr <-- Id "!=" Value;
        [LT]       RelExpr <-- Id "<" Value;
        [LTE]      RelExpr <-- Id "<=" Value;
        [GT]       RelExpr <-- Id ">" Value;
        [GTE]      RelExpr <-- Id ">=" Value;

        categories:
            Operator = {"=", "<>", "!=", "<", "<=", ">", ">="};
    }

    role(evaluation) {
        [EQ] .{
            $EQ[0].scope = $EQ[1].value;
            Predicate<Tuple> relation = tuple -> tuple.get($EQ[1].value).equals($EQ[2].value);
            $EQ[0].relation = relation;
        }.
        [NEQ] .{
            $NEQ[0].scope = $NEQ[1].value;
            Predicate<Tuple> relation = tuple -> !tuple.get($NEQ[1].value).equals($NEQ[2].value);
            $NEQ[0].relation = relation;
        }.
        [NEQ_ALT] .{
            $NEQ_ALT[0].scope = $NEQ_ALT[1].value;
            Predicate<Tuple> relation = tuple -> !tuple.get($NEQ_ALT[1].value).equals($NEQ_ALT[2].value);
            $NEQ_ALT[0].relation = relation;
        }.
        [LT] .{
            $LT[0].scope = $LT[1].value;
            Predicate<Tuple> relation = tuple -> ((Comparable) tuple.get($LT[1].value)).compareTo($LT[2].value) < 0;    //TODO: improve this part (cast)
            $LT[0].relation = relation;
        }.
        [LTE] .{
            $LTE[0].scope = $LTE[1].value;
            Predicate<Tuple> relation = tuple -> ((Comparable) tuple.get($LTE[1].value)).compareTo($LTE[2].value) <= 0;
            $LTE[0].relation = relation;
        }.
        [GT] .{
            $GT[0].scope = $GT[1].value;
            Predicate<Tuple> relation = tuple -> ((Comparable) tuple.get($GT[1].value)).compareTo($GT[2].value) > 0;
            $GT[0].relation = relation;
        }.
        [GTE] .{
            $GTE[0].scope = $GTE[1].value;
            Predicate<Tuple> relation = tuple -> ((Comparable) tuple.get($GTE[1].value)).compareTo($GTE[2].value) >= 0;
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
            RelExpr;
        }

        requires {
            Id;
            Value;
            ValueList;
        }   

        [BTW]   RelExpr <-- Id "BETWEEN" Value "AND" Value;
        [IN]    RelExpr <-- Id "IN" "(" ValueList ")";

        categories:
            Operator = {"BETWEEN", "IN"};
    }

    role(evaluation) {
        [BTW] .{
            $BTW[0].scope = $BTW[1].value;
            Predicate<Tuple> relation = tuple -> {
                Comparable value = (Comparable) tuple.get($BTW[1].value);
                return value.compareTo($BTW[2].value) >= 0 && value.compareTo($BTW[3].value) <= 0;
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
    }
}