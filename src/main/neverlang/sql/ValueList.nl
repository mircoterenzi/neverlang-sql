module sql.ValueList {
    reference syntax {
        ValueList <-- Value "," ValueList;
        ValueList <-- Value;
    }
}