bundle sql.SQLDeclarationConcern {
    slices  sql.DataDeclaration
            sql.DataList
            sql.TypeDeclaration
            sql.Constraints
            
}

module sql.DataDeclaration {
    reference syntax {
        [NORMAL] Data <-- Id Type;
        [WITH_CONTRAINT] Data <-- Id Type Constraint;
    }

    role(evaluation) {
        [NORMAL] @{
            $NORMAL[0].value = $NORMAL[1].value;
            $NORMAL[0].type = $NORMAL[2].type;
            $NORMAL[0].isNotNull = false;
            $NORMAL[0].isUnique = false;
        }.
        [WITH_CONTRAINT] @{
            $WITH_CONTRAINT[0].value = $WITH_CONTRAINT[1].value;
            $WITH_CONTRAINT[0].type = $WITH_CONTRAINT[2].type;
            $WITH_CONTRAINT[0].isNotNull = $WITH_CONTRAINT[3].isNotNull;
            $WITH_CONTRAINT[0].isUnique = $WITH_CONTRAINT[3].isUnique;
        }.
    }
}

module sql.TypeDeclaration {
    reference syntax {
        [INT_TYPE]
            Type <-- "INT";
        [FLOAT_TYPE]
            Type <-- "FLOAT";
        [VARCHAR_TYPE]
            Type <-- "VARCHAR" "(" Integer ")";    //TODO: the number of char is fake atm
        [BOOLEAN_TYPE]
            Type <-- "BOOLEAN";
    }
    
    role(evaluation) {
        [INT_TYPE] .{
            $INT_TYPE[0].type = Types.INT;
        }.
        [FLOAT_TYPE] .{
            $FLOAT_TYPE[0].type = Types.FLOAT;
        }.
        [VARCHAR_TYPE] .{
            $VARCHAR_TYPE[0].type = Types.VARCHAR;
        }.
        [BOOLEAN_TYPE] .{
            $BOOLEAN_TYPE[0].type = Types.BOOLEAN;
        }.
    }
}

module sql.Constraints {
    reference syntax {
        [NOT_NULL]  Constraint <-- "NOT" "NULL";
        [KEY]       Constraint <-- "PRIMARY" "KEY";
        [UNIQUE]    Constraint <-- "UNIQUE";
    }

    role(evaluation) {
        [NOT_NULL] .{
            $NOT_NULL[0].isNotNull = true;
            $NOT_NULL[0].isUnique = false;
        }.
        [KEY] .{
            $KEY[0].isNotNull = true;
            $KEY[0].isUnique = true;
        }.
        [UNIQUE] .{
            $UNIQUE[0].isNotNull = false;
            $UNIQUE[0].isUnique = true;
        }.
    }
}

module sql.DataList {
    reference syntax {
        DataList <-- Data "," DataList;
        DataList <-- Data;
    }
}
