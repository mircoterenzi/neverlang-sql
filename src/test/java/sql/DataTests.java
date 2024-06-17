package sql;

import neverlang.junit.NeverlangExt;
import neverlang.junit.NeverlangUnit;
import neverlang.junit.NeverlangUnitParam;
import neverlang.runtime.ASTNode;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(NeverlangExt.class)
@NeverlangUnit(language = StructuredQueryLang.class)
public class DataTests {
    @Test
    void testAddValues(@NeverlangUnitParam(files = "sql/add-values.sql") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertInstanceOf(DatabaseMap.class, db);
        var table = ((DatabaseMap) db).get("Panetteria");
        assertEquals("Rosetta 10 \n", table.toString());    //todo: temporary solution
    }
}
