module sql.ElementIdentifier {
    reference syntax {
        id:
            Id <-- String;
    }

    role(evaluation) {
        id: .{
            $id.id = $id[1].val;
        }.
    }
}