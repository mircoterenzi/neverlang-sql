module sql.DataList {
    reference syntax {
        DataList <-- Data "," DataList;
        DataList <-- Data;
    }
}