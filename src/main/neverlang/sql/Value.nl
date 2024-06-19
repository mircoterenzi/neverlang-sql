module sql.Value {
    reference syntax {
        string:
            Value <-- /\w+/;        //TODO: use just one regex.
        number:
            Value <-- /[0-9]+/;
        float:
            Value <-- /[0-9]*\.[0-9]+/;
    }

    role (evaluation) {
        string: .{
            $string.id = #0.text;
        }.
        number: .{
            $number.id = #0.text;
        }.
        float: .{
            $float.id = #0.text;
        }.
    }
}