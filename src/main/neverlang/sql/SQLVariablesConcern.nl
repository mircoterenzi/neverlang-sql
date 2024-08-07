bundle sql.SQLVariablesConcern {
    slices  sql.Value
            sql.ValueList
}

module sql.Value {
    reference syntax {
        [STRING]    String <-- /[a-zA-Z]+/;
                    Value <-- String;

        [INT]       Integer <-- /\d+/;
                    Value <-- Integer;

        [FLOAT]     Float <-- /\d*\.\d+/;
                    Value <-- Float;
    }

    role (evaluation) {
        [STRING] .{
            $STRING[0].val = #0.text;
        }.
        [INT] .{
            $INT[0].val = #0.text;
        }.
        [FLOAT] .{
            $FLOAT[0].val = #0.text;
        }.
    }
}

module sql.ValueList {
    reference syntax {
        ValueList <-- Value "," ValueList;
        ValueList <-- Value;
    }
}