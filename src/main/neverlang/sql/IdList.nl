module sql.IdList {
    reference syntax {
        IdList <-- Id "," IdList;
        IdList <-- Id;
    }
}