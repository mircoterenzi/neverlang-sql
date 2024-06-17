package sql;

import java.util.List;
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
    void testInsertInto(@NeverlangUnitParam(files = "sql/add-values.sql") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertInstanceOf(DatabaseMap.class, db);
        System.out.println(((DatabaseMap) db).get("Panetteria").toString());
    }

    @Test
    void testSelectAll(@NeverlangUnitParam(files = "sql/add-values.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of(List.of("Rosetta", "Ciabatta", "Arabo"),List.of("10", "2", "13")),
            db.get("Panetteria").getValues()
        );
    }

    @Test
    void testSelectColumn(@NeverlangUnitParam(files = "sql/add-values.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of(List.of("Rosetta", "Ciabatta", "Arabo")),
            db.get("Panetteria").getValues(List.of("nomePane"))
        );
    }
}
