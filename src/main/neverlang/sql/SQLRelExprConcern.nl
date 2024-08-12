bundle sql.SQLRelExprConcern {
    slices  sql.RelationalExpression
            sql.ComplexExpression
}

module sql.RelationalExpression {
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
            //$EQ[0].relation = obj -> obj.equals($EQ[2].value); //TODO: use a java function or predicate.
        }.
        //TODO: Implement the rest of the relational operators
    }
}

module sql.ComplexExpression {
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
        //TODO: Implement the evaluation of the complex expressions
    }
}

