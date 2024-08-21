bundle sql.SQLBoolExprConcern {
    slices  sql.AndExpression
            sql.OrExpression
            sql.NotExpression
}

module sql.AndExpression {
    imports {
        java.util.function.Predicate;
    }

    reference syntax {
        provides {
            RelExpr;
        }
        requires {
            RelExpr;
        }

        [AND] RelExpr <-- RelExpr "AND" RelExpr;

        categories:
            BoolOperator = {"AND"};
    }

    role(evaluation) {
        [AND] .{
            Predicate<Tuple> filter = obj -> ((Predicate<Tuple>) $AND[1].relation).test(obj) && ((Predicate<Tuple>) $AND[2].relation).test(obj);
            $AND[0].relation = (Predicate<Tuple>) filter;
        }.
    }
}

module sql.OrExpression {
    imports {
        java.util.function.Predicate;
    }

    reference syntax {
        provides {
            RelExpr;
        }
        requires {
            RelExpr;
        }

        [OR] RelExpr <-- RelExpr "OR" RelExpr;

        categories:
            BoolOperator = {"OR"};
    }

    role(evaluation) {
        [OR] .{
            Predicate<Tuple> filter = obj -> ((Predicate<Tuple>) $OR[1].relation).test(obj) || ((Predicate<Tuple>) $OR[2].relation).test(obj);
            $OR[0].relation = filter;
        }.
    }
}

module sql.NotExpression {
    imports {
        java.util.function.Predicate;
    }
    
    reference syntax {
        provides {
            RelExpr;
        }
        requires {
            RelExpr;
        }

        [NOT] RelExpr <-- "NOT" RelExpr;

        categories:
            BoolOperator = {"NOT"};
    }

    role(evaluation) {
        [NOT] .{
            Predicate<Tuple> filter = obj -> !((Predicate<Tuple>) $NOT[1].relation).test(obj);
            $NOT[0].relation = filter;
        }.
    }
}


