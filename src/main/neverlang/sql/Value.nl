module sql.Value {
    reference syntax {
        string:
            String <-- /[a-zA-Z]+/;
            Value <-- String;
        integer:
            Integer <-- /\d+/;
            Value <-- Integer;
        float:
            Float <-- /\d*\.\d+/;
            Value <-- Float;
    }

    role (evaluation) {
        string: .{
            $string.id = #0.text;
        }.
        integer: .{
            $integer.id = #0.text;
        }.
        float: .{
            $float.id = #0.text;
        }.
    }
}