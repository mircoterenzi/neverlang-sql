package sql;

import static org.junit.jupiter.api.Assertions.*;

import neverlang.junit.NeverlangExt;
import neverlang.junit.NeverlangUnit;
import neverlang.junit.NeverlangUnitParam;
import neverlang.runtime.ASTNode;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;


@ExtendWith(NeverlangExt.class)
@NeverlangUnit(language = SQLang.class)
public class DataTests {
    @Test
    void testInsertInto(@NeverlangUnitParam(files = "sql/insert-values.sql") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertInstanceOf(DatabaseMap.class, db);
    }

    @Test
    void testSelectAll(@NeverlangUnitParam(files = "sql/select-all.sql") ASTNode node) {
        //TODO
    }

    @Test
    void testSelectColumn(@NeverlangUnitParam(files = "sql/select-column.sql") ASTNode node) {
        //TODO
    }
}
