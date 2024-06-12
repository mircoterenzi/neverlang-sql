module sql.DataList {
    reference syntax {
        DataList <-- DataList "," Data;
        DataList <-- Data;
    }
}