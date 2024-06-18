module sql.OperationList {
    reference syntax {
        single:
            OperationList <-- Operation;
        list:
            OperationList <-- OperationList ";" Operation;
            Operation <-- "";
    }
}