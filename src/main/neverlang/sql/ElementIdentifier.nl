module sql.ElementIdentifier {
    reference syntax {
        id:
            Id <-- /[a-zA-Z]+/;
    }

    role(evaluation) {
        id: .{
            $id.id = #0.text;
        }.
    }
}