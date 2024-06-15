module sql.DataList {
    reference syntax {
        list:
            DataList <-- Data "," DataList;
            DataList <-- Data;
    }
}