bundle sql.SQLAggregateFunConcern { //TODO: think how to manage this concern.
    slices sql.CountFunction
           sql.SumFunction
           sql.AvgFunction
           sql.MinFunction
           sql.MaxFunction
}

module sql.CountFunction {
    reference syntax {
        provides {
            Value;
        }
        requires {
            Id;
        }

        [COUNT] Value <-- "COUNT" "(" Id ")";

        categories:
            AggregateFunction = {"COUNT"};
    }

    role(evaluation) {
        [COUNT] .{
            //TODO: Implement the sum function.
        }.
    }
}

module sql.SumFunction {
    reference syntax {
        provides {
            Value;
        }
        requires {
            Id;
        }

        [SUM] Value <-- "SUM" "(" Id ")";

        categories:
            AggregateFunction = {"SUM"};
    }

    role(evaluation) {
        [SUM] .{
            //TODO: Implement the sum function.
        }.
    }
}

module sql.AvgFunction {
    reference syntax {
        provides {
            Value;
        }
        requires {
            Id;
        }

        [AVG] Value <-- "AVG" "(" Id ")";

        categories:
            AggregateFunction = {"AVG"};
    }

    role(evaluation) {
        [AVG] .{
            //TODO: Implement the sum function.
        }.
    }
}

module sql.MinFunction {
    reference syntax {
        provides {
            Value;
        }
        requires {
            Id;
        }

        [MIN] Value <-- "MIN" "(" Id ")";

        categories:
            AggregateFunction = {"MIN"};
    }

    role(evaluation) {
        [MIN] .{
            //TODO: Implement the sum function.
        }.
    }
}

module sql.MaxFunction {
    reference syntax {
        provides {
            Value;
        }
        requires {
            Id;
        }

        [MAX] Value <-- "MAX" "(" Id ")";

        categories:
            AggregateFunction = {"MAX"};
    }

    role(evaluation) {
        [MAX] .{
            //TODO: Implement the sum function.
        }.
    }
}
