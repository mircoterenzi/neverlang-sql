module sql.Value {
    reference syntax {
        string:
            String <-- /[a-zA-Z]+/;
        integer:
            Integer <-- /\d+/;
        float:
            Float <-- /\d*\.\d+/;
        value:
            Value <-- String;
            Value <-- Integer;
            Value <-- Float;
    }

    role (ids) {
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