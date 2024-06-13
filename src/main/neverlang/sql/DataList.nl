module sql.DataList {
    reference syntax {
        list:
            DataList <-- DataList "," Data;
            DataList <-- Data;
    }
}