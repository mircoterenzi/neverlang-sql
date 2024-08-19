bundle sql.SQLVariablesConcern {
    slices  sql.ValueList
            sql.Value
}

module sql.ValueList {
    reference syntax {
        provides {
            ValueList;
        }
        
        requires {
            Value;
        }

        ValueList <-- Value "," ValueList;
        ValueList <-- Value;
    }
}

module sql.Value {
    imports {
        sql.types.SQLString;
        sql.types.SQLInteger;
        sql.types.SQLFloat;
        sql.types.SQLBoolean;
    }
    
    reference syntax {
        provides {
            Value;
            String;
            Integer;
            Float;
            Bool;
            Null;
        }
        
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
            $STRING[0].value = new SQLString(#0.matches.group(2));
        }.
        [INT] .{
            $INT[0].value = new SQLInteger(Integer.parseInt(#0.text));
        }.
        [FLOAT] .{
            $FLOAT[0].value = new SQLFloat(Float.parseFloat(#0.text));
        }.
        [BOOL] .{
            $BOOL[0].value = new SQLBoolean(Boolean.parseBoolean(#0.text));
        }.
        [NULL] .{
            $NULL[0].value = null;
        }.
    }
}
