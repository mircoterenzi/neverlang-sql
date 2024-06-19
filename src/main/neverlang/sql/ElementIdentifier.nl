module sql.ElementIdentifier {
    reference syntax {
        id:
            Id <-- /\w+/;
    }

    role(evaluation) {
        id: .{
            $id.id = #0.text;
        }.
    }
}