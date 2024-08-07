bundle sql.SQLVariablesConcern {
    slices  sql.Value
            sql.ValueList
}

module sql.Value {
    reference syntax {
        [STRING]    String <-- /([\"'])((?:\\\1|.)*?)\1/[string];
                    Value <-- String;

        [INT]       Integer <-- /[-+]?\b\d+\b/[integer];
                    Value <-- Integer;

        [FLOAT]     Float <-- /[-+]?\d*\.\d+(?:[eE][-+]?\d+)?/[floating];
                    Value <-- Float;
        
        [BOOL]      Bool <-- /\b(?:TRUE|FALSE)\b/[boolean];
                    Value <-- Bool;

        [NULL]      Null <-- "NULL";
                    Value <-- Null;
    }

    role (evaluation) {
        [STRING] .{
            $STRING[0].value = #0.matches.group(2);
        }.
        [INT] .{
            $INT[0].value = Integer.parseInt(#0.text);
        }.
        [FLOAT] .{
            $FLOAT[0].value = Float.parseFloat(#0.text);
        }.
        [BOOL] .{
            $BOOL[0].value = Boolean.parseBoolean(#0.text);
        }.
        [NULL] .{
            $NULL[0].value = null;
        }.
    }
}

module sql.ValueList {
    reference syntax {
        ValueList <-- Value "," ValueList;
        ValueList <-- Value;
    }
}