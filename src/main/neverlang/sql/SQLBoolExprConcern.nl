bundle sql.SQLBoolExprConcern {
    slices sql.Where
            sql.AndExpression
            sql.OrExpression
            sql.NotExpression
}

module sql.AndExpression {
    reference syntax {
        provides {
            BoolExpr;
        }
        requires {
            RelExpr;
        }

        [AND] BoolExpr <-- RelExpr "AND" RelExpr;

        categories:
            BoolOperator = {"AND"};
    }

    role(evaluation) {
        [AND] .{
            //$AND[0].relation = obj -> $AND[0].relation && $AND[1].relation;
        }.
    }
}

module sql.OrExpression {
    reference syntax {
        provides {
            BoolExpr;
        }
        requires {
            RelExpr;
        }

        [OR] BoolExpr <-- RelExpr "OR" RelExpr;

        categories:
            BoolOperator = {"OR"};
    }

    role(evaluation) {
        [OR] .{
            //$OR[0].relation = obj -> $OR[0].relation || $OR[1].relation;
        }.
    }
}

module sql.NotExpression {
    reference syntax {
        provides {
            BoolExpr;
        }
        requires {
            RelExpr;
        }

        [NOT] BoolExpr <-- "NOT" RelExpr;

        categories:
            BoolOperator = {"NOT"};
    }

    role(evaluation) {
        [NOT] .{
            //$NOT[0].relation = obj -> !$NOT[0].relation;
        }.
    }
}

