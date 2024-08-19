bundle sql.SQLBoolExprConcern {
    slices sql.Where
            sql.AndExpression
            sql.OrExpression
            sql.NotExpression
}

module sql.AndExpression {
    imports {
        java.util.function.Predicate;
        sql.types.SQLType;
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
            Predicate<SQLType> filter = obj -> ((Predicate<SQLType>) $AND[1].relation).test(obj) && ((Predicate<SQLType>) $AND[2].relation).test(obj);
            $AND[0].relation = (Predicate<SQLType>) filter;
        }.
    }
}

module sql.OrExpression {
    imports {
        java.util.function.Predicate;
        sql.types.SQLType;
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
            Predicate<SQLType> filter = obj -> ((Predicate<SQLType>) $OR[1].relation).test(obj) || ((Predicate<SQLType>) $OR[2].relation).test(obj);
            $OR[0].relation = filter;
        }.
    }
}

module sql.NotExpression {
    imports {
        java.util.function.Predicate;
        sql.types.SQLType;
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
            Predicate<SQLType> filter = obj -> !((Predicate<SQLType>) $NOT[1].relation).test(obj);
            $NOT[0].relation = filter;
        }.
    }
}

