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
public class AppTest {
    @Test
    void testReturnsDB(@NeverlangUnitParam(source = "CREATE TABLE Panetteria(nomePane string, qtKg double)") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertInstanceOf(DatabaseMap.class, db);
        assertTrue(((DatabaseMap) db).containsKey("Panetteria"));
    }

    @Test
    void testReturnsCorrectVariables(@NeverlangUnitParam(source = "CREATE TABLE Panetteria(nomePane string, qtKg double)") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(List.of("nomePane", "qtKg"), db.get("Panetteria"));
    }

    @Test
    void testAddColumn(@NeverlangUnitParam(files = "sql/add-col.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(List.of("nomePane", "qtKg", "prezzoKg"), db.get("Panetteria"));
    }

    @Test
    void testDropColumn(@NeverlangUnitParam(files = "sql/drop-col.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(List.of("nomePane"), db.get("Panetteria"));
    }

    @Test
    void testDropTable(@NeverlangUnitParam(files = "sql/drop-table.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertFalse(db.containsKey("Panetteria"));
    }

    @Test
    void testMultiple(@NeverlangUnitParam(files = "sql/multiple-operations.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertTrue(db.containsKey("Panetteria"));
        assertTrue(db.containsKey("Fioraio"));
        assertEquals(List.of("qtKg", "prezzoKg"), db.get("Panetteria"));
        assertEquals(List.of("nomeFiore"), db.get("Fioraio"));
    }
}
