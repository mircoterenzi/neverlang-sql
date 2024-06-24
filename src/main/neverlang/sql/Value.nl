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

    role (values) {
        string: .{
            $string.val = #0.text;
        }.
        integer: .{
            $integer.val = #0.text;
        }.
        float: .{
            $float.val = #0.text;
        }.
    }
}