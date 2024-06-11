module sql.ElementIdentifier {
    reference syntax {
        id:
            Id <-- /[a-zA-Z]+/;
    }

    role(evaluation) {
        id: .{
            $id.value = #0.text;
        }.
    }
}