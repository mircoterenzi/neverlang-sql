bundle sql.SQLBoolExprConcern {
    slices sql.Where
            sql.AndExpression
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
            Predicate<Object> filter = obj -> ((Predicate<Object>) $AND[1].relation).test(obj) && ((Predicate<Object>) $AND[2].relation).test(obj);
            $AND[0].relation = (Predicate<Object>) filter;
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
            Predicate<Object> filter = obj -> ((Predicate<Object>) $OR[1].relation).test(obj) || ((Predicate<Object>) $OR[2].relation).test(obj);
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
            Predicate<Object> filter = obj -> !((Predicate<Object>) $NOT[1].relation).test(obj);
            $NOT[0].relation = filter;
        }.
    }
}

